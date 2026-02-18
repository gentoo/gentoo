#!/usr/bin/env python3
# Spdx-License-Identifier: GPL-2.0-or-later
# A wrapper script to generate support files, see #684550 #706786 #968958
# Use upstream's python installer script to generate support files
# This replaces fragile sed commands and handles @@include@@ directives.
# It'll also verify that all substitution markers have been resolved, meaning that
# future changes to templates that add new variables will be caught during the build.
import sys
import argparse
from pathlib import Path

# Add upstream installer script to search path
sys.path.insert(0, str(Path.cwd() / "chrome/installer/linux/common"))
import installer


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i",
        "--installdir",
        required=True,
        help="Installation directory (e.g. /usr/lib/chromium-browser)",
    )
    args = parser.parse_args()

    # Configure contexts strictly for file generation
    # Common variables used across templates
    context = {
        "BUGTRACKERURL": "https://bugs.gentoo.org/enter_bug.cgi?product=Gentoo Linux&component=Current packages",
        "DEVELOPER_NAME": "The Chromium Authors",
        "EXTRA_DESKTOP_ENTRIES": "",
        "FULLDESC": "An open-source browser project that aims to build a safer, faster, and more stable way to experience the web.",
        "HELPURL": "https://wiki.gentoo.org/wiki/Chromium",
        "INSTALLDIR": args.installdir,
        "MAINTMAIL": "Gentoo Chromium Project <chromium@gentoo.org>",
        "MENUNAME": "Chromium",
        "PACKAGE": "chromium-browser",
        "PRODUCTURL": "https://www.chromium.org/",
        "PROGNAME": "chrome",
        "PROJECT_LICENSE": "BSD, LGPL-2, LGPL-2.1, MPL-1.1, MPL-2.0, Apache-2.0, and others",
        "SHORTDESC": "Open-source foundation of many web browsers including Google Chrome",
        "URI_SCHEME": "x-scheme-handler/chromium",
        "USR_BIN_SYMLINK_NAME": "chromium-browser",
    }

    # upstream is currently (M145) converting from upper to lower case
    # we need to support both until we drop old versions _and_ the conversion is complete.
    for key in list(context):
        context[key.lower()] = context[key]

    # Generate Desktop file
    installer.process_template(
        Path("chrome/installer/linux/common/desktop.template"),
        Path("out/Release/chromium-browser-chromium.desktop"),
        context,
    )

    # Generate Manpage
    installer.process_template(
        Path("chrome/app/resources/manpage.1.in"),
        Path("out/Release/chromium-browser.1"),
        context,
    )

    # Generate AppData (AppStream)
    installer.process_template(
        Path("chrome/installer/linux/common/appdata.xml.template"),
        Path("out/Release/chromium-browser.appdata.xml"),
        context,
    )

    # Generate GNOME Default Apps entry
    installer.process_template(
        Path("chrome/installer/linux/common/default-app.template"),
        Path("out/Release/chromium-browser.xml"),
        context,
    )


if __name__ == "__main__":
    main()
