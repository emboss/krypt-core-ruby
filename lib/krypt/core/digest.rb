module Krypt
  class Digest
    include Krypt::Provider::LibC

    class DigestError < StandardError
    end

    %w(SHA1 SHA224 SHA256 SHA384 SHA512 RIPEMD160 MD5).each do |algo|
      klass = Class.new(Digest) do
        define_method(:initialize) do
          super(algo)
        end 
      end
      const_set(algo, klass)
    end

    def initialize(type)
      unless (@handle = interface_for_name(type))
        unless (@handle = interface_for_oid(type))
          raise DigestError.new("Unknown digest algorithm: #{type}")
        end
      end
    end

    def reset
      result = @handle.interface[:md_reset].call(@handle.container)
      raise DigestError.new("Error while resetting digest") unless result == 1
      self
    end

    def update(data)
      result = @handle.interface[:md_update].call(@handle.container, data, data.length)
      raise DigestError.new("Error while updating digest") unless result == 1
      self
    end
    alias << update

    def digest(data=nil)
      if data
        ret = digest_once(data)
      else
        ret = digest_finalize
      end
      reset
      ret
    end

    def digest_length
      read_length(@handle.interface[:md_digest_length])
    end

    def block_length
      read_length(@handle.interface[:md_block_length])
    end

    def name
      name_ptr = FFI::MemoryPointer.new(:pointer)
      result = @handle.interface[:md_name].call(@handle.container, name_ptr)
      raise DigestError.new("Error while obtaining digest name") unless result == 1

      name_ptr.read_pointer.read_string
    end

    private

    def digest_once(data)
      digest_ptr = FFI::MemoryPointer.new(:pointer)
      size_ptr = FFI::MemoryPointer.new(:pointer)
      result = @handle.interface[:md_digest].call(@handle.container, data, data.length, digest_ptr, size_ptr)
      raise DigestError.new("Error while computing digest") unless result == 1

      digest_ptr = digest_ptr.read_pointer
      size = size_ptr.read_int
      ret = digest_ptr.read_string(size)
      free(digest_ptr)
      ret
    end

    def digest_finalize
      digest_ptr = FFI::MemoryPointer.new(:pointer)
      size_ptr = FFI::MemoryPointer.new(:pointer)
      result = @handle.interface[:md_final].call(@handle.container, digest_ptr, size_ptr)
      raise DigestError.new("Error while computing digest") unless result == 1

      digest_ptr = digest_ptr.read_pointer
      size = size_ptr.read_int
      ret = digest_ptr.read_string(size)
      free(digest_ptr)
      ret
    end

    def read_length(fp)
      size_ptr = FFI::MemoryPointer.new(:pointer)
      result = fp.call(@handle.container, size_ptr)
      raise DigestError.new("Error while obtaining block length") unless result == 1

      size_ptr.read_int
    end

    def interface_for_name(name)
      digest_ctor = Krypt::Provider::DEFAULT_PROVIDER[:md_new_name]
      get_native_handle(digest_ctor, name)
    end

    def interface_for_oid(oid)
      digest_ctor = Krypt::Provider::DEFAULT_PROVIDER[:md_new_oid]
      get_native_handle(digest_ctor, oid)
    end

    def get_native_handle(digest_ctor, type)
      container_ptr = digest_ctor.call(Krypt::Provider::DEFAULT_PROVIDER, type)
      return nil if nil == container_ptr || container_ptr.null?

      container = Krypt::Provider::KryptMd.new(container_ptr)
      interface_ptr = container[:methods]
      interface = Krypt::Provider::DigestInterface.new(interface_ptr)
      NativeHandle.new(container, interface)
    end

    class NativeHandle
      attr_reader :container
      attr_reader :interface

      def initialize(container, interface)
        @container = container
        @interface = interface
      end
    end
  end
end

