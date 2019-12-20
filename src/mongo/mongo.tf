provider "mongodbatlas" {}

resource "mongodbatlas_project" "tf-project1" {
  name   = "tf-project"
  org_id = "5dd28f459ccf64a539ae0817"
}

resource "mongodbatlas_cluster" "test" {
  project_id   = mongodbatlas_project.tf-project1.id
  name         = "test"
  num_shards   = 1

  replication_factor           = 3
  backup_enabled               = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.0"

  //Provider Settings "block"
  provider_name               = "GCP"
  disk_size_gb                = 40
  provider_instance_size_name = "M10"
  provider_region_name        = "US_EAST_4"
}

resource "mongodbatlas_project_ip_whitelist" "all" {
  project_id = mongodbatlas_project.tf-project1.id

  whitelist {     # TODO generalize this to allow for expansion/contraction of allowed addressed/masks
    ip_address = "73.219.16.95"
    comment    = "home.tom.org"
  }
  whitelist {
    cidr_block = "12.154.151.0/24"    # TODO make this correct
    comment    = "Aetna Burlington1"
  }

  whitelist {
    cidr_block = "12.252.19.0/24"    # TODO make this correct
    comment    = "Aetna Burlington2"
  }
}
resource "mongodbatlas_database_user" "test" {
    username      = "tom"
    password      = "begin-#!##password##$#@@!-end"   # TODO integrate Vault here?
    project_id    = mongodbatlas_project.tf-project1.id
    database_name = "admin"

    roles {
        role_name     = "readWrite"
        database_name = "admin"
    }

    roles {
        role_name       = "readWrite"
        database_name   = "newDb" # this gets created on provisioning of this
        collection_name = "newCollection" # this gets created on provisioning of this
    }
}
