terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

######################################################################
#                    Create Security List                            #
######################################################################

resource "oci_core_security_list" "security_list_spoke" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = var.spoke_security_list_display_name

  egress_security_rules {
    destination      = var.security_list_egress_destination
    protocol         = var.security_list_egress_protocol
    description      = var.security_list_egress_description
    destination_type = var.security_list_egress_destination_type
  }
  ingress_security_rules {
    protocol    = var.security_list_ingress_protocol
    source      = var.security_list_ingress_source
    description = var.security_list_ingress_description
    source_type = var.security_list_ingress_source_type
    dynamic "tcp_options" {
      iterator = tcp_options
      for_each = (var.tcp_options_destination_port_range == 0) ? [] : [var.tcp_options_destination_port_range]
      content {
        min = tcp_options.value
        max = tcp_options.value
        dynamic "source_port_range" {
          iterator = source_port_range
          for_each = (var.tcp_options_source_port_range == 0) ? [] : [var.tcp_options_source_port_range]
          content {
            min = source_port_range.value
            max = source_port_range.value
          }
        }
      }
    }
  }
}
