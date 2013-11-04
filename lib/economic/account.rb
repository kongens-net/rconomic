require 'economic/entity'

module Economic
  class Account < Entity
    has_properties :name, :number, :balance, :block_direct_entries, :contra_account, :debit_credit, :department, :distribution_key, :is_accessible, :opening_account, :total_from, :type, :vat_account
    
    
    def handle
      Handle.build({:number => @number})
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
