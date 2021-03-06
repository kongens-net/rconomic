require 'economic/entity'

module Economic

  # Represents a cash book in E-conomic.
  #
  # API documentation: http://www.e-conomic.com/apidocs/Documentation/T_Economic_Api_ICashBook.html
  class CashBook < Entity
    has_properties :name, :number

    def handle
      @handle ||= Handle.new({:number => @number})
    end

    def entries
      CashBookEntryProxy.new(self)
    end

    # Books all entries in the cashbook. Returns book result.
    def book
      response = request(:book, {
        "cashBookHandle" => handle.to_hash
      })
      response[:number].to_i
    end

    def get_next_voucher_number
      response = request(:get_next_voucher_number, {
          "cashBookHandle" => handle.to_hash
      })
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
