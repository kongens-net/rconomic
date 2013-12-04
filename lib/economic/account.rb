require 'economic/entity'

module Economic
  class Account < Entity
    has_properties :name, :number, :balance, :block_direct_entries, :contra_account, :debit_credit, :department, :distribution_key, :is_accessible, :opening_account, :total_from, :type, :vat_account_handle
    
    
    def handle
      Handle.build({:number => @number})
    end

    def vat_account
      return nil if vat_account_handle.nil?
      @vat_account ||= vat_account_handle[:vat_code]
    end

    def vat_account=(vat_account)
      vat_account = {:vat_code => vat_account} if vat_account.is_a?(String)
      self.vat_account_handle = vat_account
      @vat_account = vat_account[:vat_code]
    end

    def vat_account_handle=(handle)
      @vat_account = nil unless handle == @vat_account_handle
      @vat_account_handle = handle
    end
    
    protected
    
    def build_soap_data
      {
        'Handle' => handle.to_hash,
        'Name' => name,
        'Number' => number
      }
    end
  end
end
