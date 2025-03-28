locals {

  vm_common = { 
    platform="standard-v3", 
    family = "ubuntu-2204-lts",
    image_id      = "fd80mrhj8fl2oe87o4e1",
    cpu=2, 
    ram=1, 
    fract=20, 
    hdd_type="network-hdd", 
    disk_size=13 
  } 


  ssh_opt = {
    proto="ssh", 
    user_name="ubuntu", 
    pubkey=file("~/.ssh/id_ed25519.pub"), 
    time="120s"
  }

}