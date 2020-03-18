load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:paths.bzl", "paths")

_DOCKERCOMPOSE_TOOLCHAIN = "@rules_docker_compose//toolchain/docker_compose:toolchain_type"

_common_attr  = {
    "_script_tpl": attr.label(
        default = Label("//internal:script.sh.tpl"),
        allow_single_file = True,
    ),
    "template": attr.label_list(
        mandatory = False,
        allow_files = [".yaml", ".json"],
        # allow_empty = False,
    ),
}

def _impl(ctx):

    toolchain_info = ctx.toolchains[_DOCKERCOMPOSE_TOOLCHAIN].info
    print(toolchain_info.tool_target[DefaultInfo].files_to_run.executable.short_path)

    ctx.actions.expand_template(
        is_executable = True,
        output = ctx.outputs.executable,
        template = ctx.file._script_tpl,
        substitutions = {
            "%{CMD}": ' '.join([toolchain_info.tool_target[DefaultInfo].files_to_run.executable.short_path, "version"])
        }
    )

    toolchain_info.tool_target.files.to_list()

    return [
        DefaultInfo(
            runfiles = ctx.runfiles(
                # files = runfiles,
                transitive_files = depset(
                    toolchain_info.tool_target.files.to_list()
                )
            ),
            executable = ctx.outputs.executable
        ),
    ]


_compose_run = rule(
    executable = True,
    toolchains = [_DOCKERCOMPOSE_TOOLCHAIN],
    implementation = _impl,
    attrs = dicts.add(
        _common_attr,
        {
            "_command": attr.string(default = "run")
        },
    ),
)

def compose(name, **kwargs):
    _compose_run(name = name, **kwargs)
    _compose_run(name = name + ".run",**kwargs)
