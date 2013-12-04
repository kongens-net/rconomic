require 'economic/entity'

module Economic
  class VatAccount < Entity
    has_properties :account, :contra_account, :name, :rate_as_percent, :type, :vat_code
    
    
    def handle
      Handle.build({:vat_code => @vat_code})
    end
    
    protected
    
    def build_soap_data
      {
        'Handle' => handle.to_hash,
        'Account' => account,
        'ContraAccount' => contra_account,
        'Name' => name,
        'RateAsPercent' => rate_as_percent,
        'Type' => type,
        'VatCode' => vat_code
      }
    end
  end
end
