module IControl # :nodoc: 

  class Base

    class Struct
      
      class << self
        
        attr_accessor :attributes

        ##
        # When defining an struct we have to indicate every attribute type cause the soap responses are typed
        # This method accepts three arguments:
        #   attribute           = The name the atribute is going to be referenced in the instances (i.e. the ruby name)
        #   klass               = The Ruby class of the attribute
        #   soap_attribute_name = The soap name of the attribute in case it differs from the attribute name (DEPRECATED)

        def icontrol_attribute(attribute,klass,soap_attribute_name = nil)
          @attributes ||= {}
          @attributes[attribute] = klass 
        end

        def from_soap(xml)
          aux = {}
          @attributes.each do |k,v|
            
            if v.respond_to?(:from_soap) # v.ancestors.find{ |i| i.name  =~ /^IControl/ }              
              aux[k] = v.from_soap(xml[k])
            else
              if v == Numeric
                aux[k] = xml[k].to_i
              else
                if xml[k].empty_node?
                  aux[k] = nil
                else
                  aux[k] = xml[k]
                end
              end
            end
          end if xml
          return aux.values.compact.empty? ? nil : self.new(aux)
        end

      end    

      # Converts to soap. In this case we fallback to the hash conversion of the attributes
      def to_soap
        aux = {}
        @attributes.each {|k,v| aux[k.to_s] = v.respond_to?(:to_soap) ? v.to_soap : v }
        return aux
      end
        
      include IControl::Base::Attributable

    end
  end
end
