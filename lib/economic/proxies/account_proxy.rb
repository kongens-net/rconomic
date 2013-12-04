require 'economic/proxies/entity_proxy'
require 'economic/proxies/actions/find_by_handle_with_number'

module Economic
  class AccountProxy < EntityProxy
    include FindByHandleWithNumber
    def find_by_name(name)
      response = request('FindByName', {
        'name' => name
      })
      
      handle = response[:account_handle]
      
      entity = build(response)
      entity.name = name
      entity.number = handle[:number]
      entity.persisted = true
      entity
      
    end
  end
end
