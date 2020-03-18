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
"""
This module defines azure toolchain rules
"""

DockerComposeToolchainInfo = provider(
    doc = "Docker toolchain rule parameters",
    fields = {
        "tool_path": "Path to the docker_compose executable",
        "tool_target": "A docker_compose cli executable target built from source or downloaded.",
        "jq_tool_target": "A jq executable target to downloaded.",
        "yq_tool_target": "A yq executable target to downloaded.",
    },
)

def _docker_compose_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        info = DockerComposeToolchainInfo(
            tool_path = ctx.attr.tool_path,
            tool_target = ctx.attr.tool_target,
            jq_tool_target = ctx.attr.jq_tool_target,
            yq_tool_target = ctx.attr.yq_tool_target
        ),
    )
    return [toolchain_info]

docker_compose_toolchain = rule(
    implementation = _docker_compose_toolchain_impl,
    attrs = {
        "tool_path": attr.string(
            doc = "Path to the binary.",
        ),
        "tool_target": attr.label(
            doc = "Target to build docker_compose from binary.",
            executable = True,
            cfg = "host",
        ),
        "jq_tool_target": attr.label(
            doc = "Target to build jq from source.",
            executable = True,
            cfg = "host",
        ),
        "yq_tool_target": attr.label(
            doc = "Target to build yq from source.",
            executable = True,
            cfg = "host",
        ),
    },
)
