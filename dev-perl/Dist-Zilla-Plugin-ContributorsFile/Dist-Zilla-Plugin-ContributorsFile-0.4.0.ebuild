# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YANICK
DIST_VERSION=0.4.0
inherit perl-module

DESCRIPTION="Add a file listing all contributors"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla
	dev-perl/Moose
"
BDEPEND="${RDEPEND}
"
