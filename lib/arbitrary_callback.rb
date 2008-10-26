module LeoneImage
  module ArbitraryCallback
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def append_method(subject_method, options={})
        options = {:with_args => false}.merge(options)
        
        unless method_to_append = options[:with_method]
          raise ArgumentError, "Did not receive the name of a method to append"
        end
        
        original_subject_method = "original_#{normalize_method_name(subject_method)}"
        
        wrap_method(subject_method) do |*args|
          result = send(original_subject_method, *args)
          if options[:with_args]
            send(method_to_append, *args)
          else
            send(method_to_append)
          end
          result
        end
      end
      
      def prepend_method(subject_method, options={})
        options = {:with_args => false}.merge(options)
        
        unless method_to_prepend = options[:with_method]
          raise ArgumentError, "Did not receive the name of a method to prepend"
        end
        
        original_subject_method = "original_#{normalize_method_name(subject_method)}"
        
        wrap_method(subject_method) do |*args|
          result = send(original_subject_method, *args)
          if options[:with_args]
            send(method_to_prepend, *args)
          else
            send(method_to_prepend)
          end
          result
        end
      end
      
      def wrap_method(subject_method, &block)
        define_method(:_arbitrary_code, &block)
        
        alias_method "original_#{normalize_method_name(subject_method)}", subject_method
        
        define_method subject_method do |*args|
          _arbitrary_code(*args)
        end
      end
      
      private   #---------------------------------------------------------------
      def normalize_method_name(sym)
        sym.to_s.gsub(/=/, "_equals").to_sym
      end
    end
  end
end