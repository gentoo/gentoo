#!/usr/bin/env python
# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
#
#
# Takes the manifests/*.xml file from the NVIDIA CUDA Toolkit as input.
# Those files contain a nested tree of package items.
#
# For each package node a if block is output that checks the package's
#  name attribute against the environment provided array SKIP_COMPONENTS
#  and skips that whole package if it's listed in it.
#
# Each item contains four nodes that reference things to install,
#  `dir`, `file`, `desktopFile`, & `pcfile`, and metadata that further
#  detail these. This script will output calls to do* calls that
#  use the metadata.
# - dodir would create an empty file - we handle this in dofile
# - dofile copies a regex file glob
# - dodesktopFile creates a .desktop file
# - dopcfile creates a pkgconfig file
#
# The resulting bash code can be run inside src_install().
#
# Usage: python parse_manifest.py <cuda_aarch64.xml|cuda_x86_64.xml>


import argparse
import xml.etree.ElementTree

import defusedxml.ElementTree
from pathlib import Path

ind = "\t"
indent = 1


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('filename')  # positional argument

    args = parser.parse_args()

    basedir = Path(args.filename).parents[1]

    et = defusedxml.ElementTree.parse(args.filename)

    # Find all packages under the package with the id main (i.e. under "CUDA Installer")
    for e in et.findall("[@id='main']/package"):
        def p_package(el: xml.etree.ElementTree.Element, level: int = 0):

            skip = {
                "Documentation",  # obsolete
                "Driver",  # unused
                # "Kernel Objects",  # split
                # "Demo Suite",
                # "Visual Tools",
                # old eclipse
                # "nsight",
                # old java
                # "nvvp",
                # "cuda-gdb-src"
            }

            name = el.get("name")

            # trim leading CUDA and trailing version
            if name.startswith("CUDA"):
                name2 = ' '.join(name.split(" ")[1:-1])
            else:
                name2 = name

            if name2 in skip:
                return

            # avoid having to deal with whitespaces in bash
            name2 = name2.replace(" ", "_")

            path = ""

            print(f"{ind * (level + 0) * indent}if ! has {name2} \"${{SKIP_COMPONENTS[@]}}\"; then # \"{name}\"")

            # output attributes from unhandled tags
            for child in el:
                if child.tag == "package":
                    continue
                if child.tag == "file":
                    continue
                if child.tag == "desktopFile":
                    continue
                if child.tag == "pcfile":
                    continue
                for attrib in child.attrib:
                    print(f"{child.tag} {attrib}={child.attrib[attrib]}")

            # <name>CUDA Installer</name>
            # only for CUDA Installer
            # unused
            for node in el.findall("./name"):
                print(f"{ind * (level + 1) * indent}# {node.tag}: \"{node.text}\"")

            # <type>compiler</type>
            # category. We use the package name instead.
            # unused
            # for node in el.findall("./type"):
            #     print(f"{ind * (level + 1) * indent}# {node.tag}: \"{node.text}\"")

            # <priority>1</priority>
            # probably sorting for the tui installer
            # unused
            # for node in el.findall("./priority"):
            #     print(f"{ind * (level + 1) * indent}# {node.tag}: \"{node.text}\"")

            # <single-selection/>
            # proably for tui installer
            # unused
            # for node in el.findall("./single-selection"):
            #     print(f"{ind * (level + 1) * indent}# {node.tag}: \"{node.text}\"")

            # <koversion>2.24.2</koversion>
            # version of the installed kernel object (Kernel Objects only)
            # unused
            for node in el.findall("./koversion"):
                print(f"{ind * (level + 1) * indent}# {node.tag}: \"{node.text}\"")

            # <installPath>/usr/local/cuda-12.8</installPath>
            # overrides the install location
            # unused
            # for node in el.findall("./installPath"):
            #     print(f"{ind * (level + 1) * indent}# {node.tag}: \"{node.text}\"")

            # <buildPath>./builds/cuda_cccl/</buildPath>
            # path where the package files are found
            # we cd into it
            for node in el.findall("./buildPath"):
                path = node.text.removeprefix('./')
                print(f"{ind * (level + 1) * indent}cd \"${{S}}/{path}\" || die \"cd ${{S}}/{path} failed\"")
                print()

            # <dir>bin</dir>
            # would install empty dirs
            # unused
            # for node in el.findall("./dir"):
            #     pass

            # <file dir="bin/">.*</file>
            # <file>targets/x86_64-linux/lib/.*\.so</file>
            # regex glob of files to install.
            for node in el.findall("./file"):
                # unescape '.*' -> '*' & '\.' -> '.'
                file = (node.text
                        .replace(".*", "*")
                        .replace(r"\.", ".")
                        .replace("x86_64", "${narch}")
                        .replace("sbsa", "${narch}")
                        )

                # optional dir offset, we merge it into path
                dir = ""
                if "dir" in node.attrib:
                    dir = f" \"{Path(node.attrib['dir'])}\""

                filepath = basedir / path / file

                # ignore existing symlinks ( include, lib* ) and the uninstallers
                if not filepath.is_symlink() and not file.endswith("-uninstaller"):
                    print(f"{ind * (level + 1) * indent}dofile \"{file}\"{dir}")

            # <pcfile description="CUDA Runtime Library">opencl-12.8.pc</pcfile>
            # create a pkgconfig file for the given description and lib name/version
            for node in el.findall("./pcfile"):
                offset = node.text.rfind('-')
                if offset == -1:
                    raise RuntimeError(f"failed to split pcfile {node.text}")

                lib_name = node.text[:offset]

                if not node.text.endswith('.pc'):
                    raise RuntimeError(f"pcfile does not end in '.pc' {node.text}")
                lib_version = node.text[offset+1:-3]

                if "description" not in node.attrib:
                    raise RuntimeError(f"no description for {node.text}")

                subdir = ""
                if "subdir" in node.attrib:
                    subdir = f" \"{node.attrib['subdir']}\""

                print(f"{ind * (level + 1) * indent}dopcfile "
                      f"\"{lib_name}\" "
                      f"\"{lib_version}\" "
                      f"\"{node.attrib['description']}\"{subdir}")

            # <desktopFile
            #  filename="nsight"
            #  name="Nsight Eclipse Edition"
            #  categories="Development;IDE;Debugger;ParallelComputing"
            #  keywords="cuda;gpu;nvidia;debugger;"
            #  iconPath="libnsight/icon.xpm"
            #  execPath="bin/nsight"
            #  tryExecPath="bin/nsight"
            # />
            # create a .desktop file
            for node in el.findall("./desktopFile"):
                print(f"{ind * (level + 1) * indent}dodesktopFile \\")
                print(f"{ind * (level + 2) * indent}\"{node.attrib['filename']}\" \\")
                print(f"{ind * (level + 2) * indent}\"{node.attrib['name']}\" \\")
                print(f"{ind * (level + 2) * indent}\"{node.attrib['categories']}\" \\")
                print(f"{ind * (level + 2) * indent}\"{node.attrib['keywords']}\" \\")
                print(f"{ind * (level + 2) * indent}\"{node.attrib['iconPath']}\" \\")
                print(f"{ind * (level + 2) * indent}\"{node.attrib['execPath']}\" \\")
                print(f"{ind * (level + 2) * indent}\"{node.attrib['tryExecPath']}\"")

            # iterator over all nested packages
            for node in el.findall("./package"):
                p_package(node, level + 1)

            print(f"{ind * (level + 0) * indent}fi")

        p_package(e)


if __name__ == "__main__":
    main()
