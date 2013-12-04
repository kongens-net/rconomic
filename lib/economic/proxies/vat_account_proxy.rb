require 'economic/proxies/entity_proxy'

module Economic
  class VatAccountProxy < EntityProxy
    def find_by_vat_code(vat_code)
      response = request('FindByVatCode', {
        'vatCode' => vat_code
      })
      
      handle = response[:vat_code]
      
      entity = build(response)
      entity.persisted = true
      entity
    end
  end
end
