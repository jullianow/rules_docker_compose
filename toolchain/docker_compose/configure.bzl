def _toolchain_configure_impl(repository_ctx):

    tool_path = ""
    if repository_ctx.attr.tool_path:
        tool_path = repository_ctx.attr.tool_path
    elif repository_ctx.which("docker-compose"):
        tool_path = repository_ctx.which("docker-compose")

    tool_target = "@docker_compose//file:file"
    jq_tool_target = "@jq//file:file"
    yq_tool_target = "@yq//file:file"

    repository_ctx.template(
        "BUILD.bazel",
        Label("@rules_docker_compose//toolchain/docker_compose:BUILD.bazel.tpl"),
        {
            "%{DOCKERCOMPOSE_TOOL_PATH}": "%s" % tool_path,
            "%{DOCKERCOMPOSE_TOOL_TARGET}": tool_target,
            "%{JQ_TOOL_TARGET}": "%s" % jq_tool_target,
            "%{YQ_TOOL_TARGET}": "%s" % yq_tool_target,
        },
        False,
    )

# Repository rule to generate a databricks_toolchain target
toolchain_configure = repository_rule(
    implementation = _toolchain_configure_impl,
    attrs = {
        "tool_path": attr.string(
            mandatory = False,
            doc = "The full path to the docker-compose binary. If not specified, it will " +
                  "be searched for in the path. If not available, running commands " +
                  "that require docker-compose (e.g., incremental load) will fail.",
        ),
    },
    environ = [
        "PATH",
    ],
)
