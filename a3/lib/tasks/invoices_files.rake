
namespace :invoices_files do

task :leerXML  => :environment do

  Dir.glob('public/20220811012132-invoices/*.xml') do |rb_file|
    result = {}
    hash = Hash.from_xml(File.read(rb_file))
    #Se agrega por cada registro cambia el numero de columna por que s
      api = Invoice.new(invoice_uuid:hash['hash']['invoice_uuid'],
                        status:hash['hash']['status'],
                        emitter_name:hash['hash']['emitter']['name'],
                        emitter_rfc:hash['hash']['emitter']['rfc'] ,
                        receiver_name:hash['hash']['receiver']['name'],
                        receiver_rfc:hash['hash']['receiver']['rfc'],
                        amount:hash['hash']['amount']['cents'],
                        currency:hash['hash']['amount']['currency'],
                        cfdi_digital_stamp:hash['hash']['cfdi_digital_stamp'],
                        emitted_at:hash['hash']['emitted_at'],
                        expires_at:hash['hash']['expires_at'],
                        signed_at:hash['hash']['signed_at'],
                       )
    api.save
    end
  end
end