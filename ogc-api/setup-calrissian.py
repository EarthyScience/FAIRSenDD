#!/usr/bin/env python3

from pycalrissian.context import CalrissianContext
import base64

namespace_name = "default"

session = CalrissianContext(
    namespace=namespace_name,
    storage_class="standard",
    volume_size="10G",
    kubeconfig_file="/home/dloos/.kube/config",  # Is this actually used?
)

session.initialise()
