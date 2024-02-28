# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P="trrntzip-${PV}"
DESCRIPTION="Create identical zip archives over multiple systems"
HOMEPAGE="https://github.com/0-wiz-0/trrntzip"
SRC_URI="https://github.com/0-wiz-0/trrntzip/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
"

DOCS=(AUTHORS NEWS.md README.md)
