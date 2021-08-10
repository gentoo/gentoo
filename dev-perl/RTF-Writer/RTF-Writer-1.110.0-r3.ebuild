# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SBURKE
DIST_VERSION=1.11
inherit perl-module

DESCRIPTION="RTF::Writer - for generating documents in Rich Text Format"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-perl/Image-Size
"
BDEPEND="${RDEPEND}
"
