module Economic
  class Session
    attr_accessor :agreement_number, :user_name, :password #used for old authentication
    attr_accessor :app_token, :token #used for token authentication
    attr_accessor :authentication_method #determines which authentication method to use

    def initialize(*args)
      args.flatten!
      if args.size == 3
      	self.agreement_number, self.user_name, self.password = args
      	self.authentication_method = :connect_with_username
      elsif args.size == 2
        self.app_token, self.token = args
        self.authentication_method = :connect_with_token
      else
        raise ArgumentError.new("Wrong number of arguments (#{args.size} for 2 or 3)")
      end
    end

    def self.connect(*args)
      e = new(args)
      e.connect
      e
    end

    # Authenticates with e-conomic
    def connect
      response = self.send authentication_method
      @cookies = response.http.cookies
      response
    end

    # Provides access to the DebtorContacts
    def contacts
      @contacts ||= DebtorContactProxy.new(self)
    end

    # Provides access to the current invoices - ie invoices that haven't yet been booked
    def current_invoices
      @current_invoices ||= CurrentInvoiceProxy.new(self)
    end

    # Provides access to the invoices
    def invoices
      @invoices ||= InvoiceProxy.new(self)
    end

    # Provides access to the debtors
    def debtors
      @debtors ||= DebtorProxy.new(self)
    end

    # Provides access to creditors
    def creditors
      @creditors ||= CreditorProxy.new(self)
    end

    def cash_books
      @cash_books ||= CashBookProxy.new(self)
    end

    def cash_book_entries
      @cash_book_entries ||= CashBookEntryProxy.new(self)
    end

    def accounts
      @accounts ||= AccountProxy.new(self)
    end

    def debtor_entries
      @debtor_entries ||= DebtorEntryProxy.new(self)
    end

    def creditor_entries
      @creditor_entries ||= CreditorEntryProxy.new(self)
    end

    def entries
      @entries ||= EntryProxy.new(self)
    end

    # Requests an action from the API endpoint
    def request(action, message = nil)
      data = {:cookies => @cookies}
      data[:message] = message if message

      response = client.call(action, data)

      response_hash = response.to_hash

      response_key = "#{action}_response".intern
      result_key = "#{action}_result".intern
      if response_hash[response_key] && response_hash[response_key][result_key]
        response_hash[response_key][result_key]
      else
        {}
      end
    end

    # Returns self - used by proxies to access the session of their owner
    def session
      self
    end

    private

    # Returns the Savon::Client used to connect to e-conomic
    # Cached on class-level to avoid loading the big wsdl file more than once (can take several hunder megabytes of ram after a while...)
    def client
      @@client ||= Savon.client(:wsdl => File.expand_path(File.join(File.dirname(__FILE__), "economic.wsdl")))
    end

    def connect_with_username
      client.call :connect, :message => {
          :agreementNumber => self.agreement_number,
          :userName => self.user_name,
          :password => self.password
        }
    end

    # Authenticates with e-conomic using token
    def connect_with_token
      client.call :connect_with_token, :message => {
          :appToken => self.app_token,
          :token => self.token
        }
    end
  end
end
