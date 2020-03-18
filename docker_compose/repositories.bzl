# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Rules to load all dependencies of rules_docker_compose."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("//toolchain/docker_compose:configure.bzl", docker_compose_toolchain_configure = "toolchain_configure")

def deps():
    """Download dependencies of container rules."""
    excludes = native.existing_rules().keys()

    if "bazel_skylib" not in excludes:

        http_archive(
            name = "bazel_skylib",
            sha256 = "e5d90f0ec952883d56747b7604e2a15ee36e288bb556c3d0ed33e818a4d971f2",
            strip_prefix = "bazel-skylib-1.0.2",
            urls = [
                "https://github.com/bazelbuild/bazel-skylib/archive/1.0.2.tar.gz"
            ],
        )

    if "docker_compose" not in excludes:

        http_file(
            name = "docker_compose",
            executable = True,
            sha256 = "b3835d30f66bd3b926511974138923713a253d634315479b9aa3166c0050da98",
            urls = [
                "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-Linux-x86_64"
            ],
        )

    if "jq" not in excludes:

        http_file(
            name = "jq",
            executable = True,
            sha256 = "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44",
            urls = [
                "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
            ],
        )

    if "yq" not in excludes:

        http_file(
            name = "yq",
            executable = True,
            sha256 = "11a830ffb72aad0eaa7640ef69637068f36469be4f68a93da822fbe454e998f8",
            urls = [
                "https://github.com/mikefarah/yq/releases/download/3.2.1/yq_linux_amd64"
            ],
        )

    native.register_toolchains(
        "@rules_docker_compose//toolchain/docker_compose:default_linux_toolchain"
    )

    if "docker_compose_config" not in excludes:
        docker_compose_toolchain_configure(name = "docker_compose_config")
