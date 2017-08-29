open Mirage

let bridge_socket =
  let doc = Key.Arg.info ~doc:"bridge socket to connect to" ["path"] in
  Key.(create "socket_path" Arg.(opt string "/var/tmp/bridge" doc))


let net = netif "eth0"
let ethif = etif net
let arp = arp ethif
let ip =
  let config = {
    network = Ipaddr.V4.Prefix.of_address_string_exn "172.20.0.2";
    gateway = None
  } in
  create_ipv4 ~config ethif arp


let main = foreign "Connector.Make" (network @-> ethernet @-> arpv4 @-> ipv4 @-> job)


let () =
  let keys = [
    Key.abstract bridge_socket
  ] in
  let packages = [
    package ~sublibs:["lwt"] "logs";
    package ~sublibs:["ipv4"; "ethif"] "tcpip";
  ] in
  register ~packages ~keys "connector" [main $ net $ ethif $ arp $ ip]
