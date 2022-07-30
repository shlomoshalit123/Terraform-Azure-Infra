provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id = "${var.client_id}"
    client_secret = "${var.client_secret}"
    tenant_id = "${var.tenant_id}"

    features{}

}

variable "subscription_id" {
description = "subscription_id"
}

variable "client_id" {
description = "client_id"
}

variable "client_secret" {
description = "client_secret"
}

variable "tenant_id" {
description = "tenant_id"
}

