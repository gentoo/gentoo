# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GIT_SHA1="20cf768a5137cf2e2d77f7754496dc053fc77741"

DESCRIPTION="tool to manipulate Intel X86 and X86-64 processor microcode update collections"
HOMEPAGE="https://gitlab.com/iucode-tool/"
SRC_URI="https://gitlab.com/iucode-tool/releases/raw/${GIT_SHA1}/${PN/_/-}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
