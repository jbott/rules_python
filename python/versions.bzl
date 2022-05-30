# Copyright 2022 The Bazel Authors. All rights reserved.
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

"""The Python versions we use for the toolchains.
"""

# Values returned by https://bazel.build/rules/lib/repository_os.
MACOS_NAME = "mac os"
LINUX_NAME = "linux"
WINDOWS_NAME = "windows"

DEFAULT_RELEASE_BASE_URL = "https://github.com/indygreg/python-build-standalone/releases/download"

# When updating the versions and releases, run the following command to get
# the hashes:
#   bazel run //python/private:print_toolchains_checksums
#
# buildifier: disable=unsorted-dict-items
TOOL_VERSIONS = {
    "3.8.10": {
        "url": "20210506/cpython-{python_version}-{platform}-pgo+lto-20210506T0943.tar.zst",
        "sha256": {
            "x86_64-apple-darwin": "8d06bec08db8cdd0f64f4f05ee892cf2fcbc58cfb1dd69da2caab78fac420238",
            "x86_64-unknown-linux-gnu": "aec8c4c53373b90be7e2131093caa26063be6d9d826f599c935c0e1042af3355",
        },
        "strip_prefix": "python",
    },
    "3.8.12": {
        "url": "20220227/cpython-{python_version}+20220227-{platform}-{build}.tar.gz",
        "sha256": {
            "aarch64-apple-darwin": "f9a3cbb81e0463d6615125964762d133387d561b226a30199f5b039b20f1d944",
            # no aarch64-unknown-linux-gnu build available for 3.8.12
            "x86_64-apple-darwin": "f323fbc558035c13a85ce2267d0fad9e89282268ecb810e364fff1d0a079d525",
            "x86_64-pc-windows-msvc": "4658e08a00d60b1e01559b74d58ff4dd04da6df935d55f6268a15d6d0a679d74",
            "x86_64-unknown-linux-gnu": "5be9c6d61e238b90dfd94755051c0d3a2d8023ebffdb4b0fa4e8fedd09a6cab6",
        },
        "strip_prefix": "python",
    },
    "3.9.10": {
        "url": "20220227/cpython-{python_version}+20220227-{platform}-{build}.tar.gz",
        "sha256": {
            "aarch64-apple-darwin": "ad66c2a3e7263147e046a32694de7b897a46fb0124409d29d3a93ede631c8aee",
            "aarch64-unknown-linux-gnu": "12dd1f125762f47975990ec744532a1cf3db74ad60f4dfb476ca42deb7f78ca4",
            "x86_64-apple-darwin": "fdaf594142446029e314a9beb91f1ac75af866320b50b8b968181e592550cd68",
            "x86_64-pc-windows-msvc": "c145d9d8143ce163670af124b623d7a2405143a3708b033b4d33eed355e61b24",
            "x86_64-unknown-linux-gnu": "455089cc576bd9a58db45e919d1fc867ecdbb0208067dffc845cc9bbf0701b70",
        },
        "strip_prefix": "python",
    },
    "3.10.2": {
        "url": "20220227/cpython-{python_version}+20220227-{platform}-{build}.tar.gz",
        "sha256": {
            "aarch64-apple-darwin": "1409acd9a506e2d1d3b65c1488db4e40d8f19d09a7df099667c87a506f71c0ef",
            "aarch64-unknown-linux-gnu": "8f351a8cc348bb45c0f95b8634c8345ec6e749e483384188ad865b7428342703",
            "x86_64-apple-darwin": "8146ad4390710ec69b316a5649912df0247d35f4a42e2aa9615bffd87b3e235a",
            "x86_64-pc-windows-msvc": "a1d9a594cd3103baa24937ad9150c1a389544b4350e859200b3e5c036ac352bd",
            "x86_64-unknown-linux-gnu": "9b64eca2a94f7aff9409ad70bdaa7fbbf8148692662e764401883957943620dd",
        },
        "strip_prefix": "python",
    },
}

# buildifier: disable=unsorted-dict-items
MINOR_MAPPING = {
    "3.8": "3.8.12",
    "3.9": "3.9.10",
    "3.10": "3.10.2",
}

PLATFORMS = {
    "aarch64-apple-darwin": struct(
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
        os_name = MACOS_NAME,
        # Matches the value returned from:
        # repository_ctx.execute(["uname", "-m"]).stdout.strip()
        arch = "arm64",
    ),
    "aarch64-unknown-linux-gnu": struct(
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
        os_name = LINUX_NAME,
        # Note: this string differs between OSX and Linux
        # Matches the value returned from:
        # repository_ctx.execute(["uname", "-m"]).stdout.strip()
        arch = "aarch64",
    ),
    "x86_64-apple-darwin": struct(
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:x86_64",
        ],
        os_name = MACOS_NAME,
        arch = "x86_64",
    ),
    "x86_64-pc-windows-msvc": struct(
        compatible_with = [
            "@platforms//os:windows",
            "@platforms//cpu:x86_64",
        ],
        os_name = WINDOWS_NAME,
        arch = "x86_64",
    ),
    "x86_64-unknown-linux-gnu": struct(
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        os_name = LINUX_NAME,
        arch = "x86_64",
    ),
}

def get_release_url(platform, python_version, base_url = DEFAULT_RELEASE_BASE_URL, tool_versions = TOOL_VERSIONS):
    """Resolve the release URL for the requested interpreter version

    Args:
        platform: The platform string for the interpreter
        python_version: The version of the intterpreter to get
        base_url: The URL to prepend to the 'url' attr in the tool_versions dict
        tool_versions: A dict listing the interpreter versions, their SHAs and URL

    Returns:
        A tuple of (filename, url, and archive strip prefix)
    """

    url = tool_versions[python_version]["url"]

    if type(url) == type({}):
        url = url[platform]

    strip_prefix = tool_versions[python_version].get("strip_prefix", None)
    if type(strip_prefix) == type({}):
        strip_prefix = strip_prefix[platform]

    release_filename = url.format(
        platform = platform,
        python_version = python_version,
        build = "shared-install_only" if (WINDOWS_NAME in platform) else "install_only",
    )
    url = "/".join([base_url, release_filename])
    return (release_filename, url, strip_prefix)

def print_toolchains_checksums(name):
    native.genrule(
        name = name,
        srcs = [],
        outs = ["print_toolchains_checksums.sh"],
        cmd = """\
cat > "$@" <<'EOF'
#!/bin/bash

set -o errexit -o nounset -o pipefail

echo "Fetching hashes..."

{commands}
EOF
        """.format(
            commands = "\n".join([
                _commands_for_version(python_version)
                for python_version in TOOL_VERSIONS.keys()
            ]),
        ),
        executable = True,
    )

def _commands_for_version(python_version):
    return "\n".join([
        "echo \"{python_version}: {platform}: $$(curl --location --fail {release_url_sha256} 2>/dev/null || curl --location --fail {release_url} 2>/dev/null | shasum -a 256 | awk '{{ print $$1 }}')\"".format(
            python_version = python_version,
            platform = platform,
            release_url = get_release_url(platform, python_version)[1],
            release_url_sha256 = get_release_url(platform, python_version)[1] + ".sha256",
        )
        for platform in TOOL_VERSIONS[python_version]["sha256"].keys()
    ])

def gen_python_config_settings(name = ""):
    for platform in PLATFORMS.keys():
        native.config_setting(
            name = "{name}{platform}".format(name = name, platform = platform),
            constraint_values = PLATFORMS[platform].compatible_with,
        )
