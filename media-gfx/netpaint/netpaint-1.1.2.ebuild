# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

MY_PN="NetPaint"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="curses-based drawing tool"
HOMEPAGE="https://github.com/SyntheticDreams/NetPaint"
SRC_URI="https://github.com/SyntheticDreams/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	mv netpaint.py netpaint || die
	sed -e 's#netpaint\.py#netpaint#g;' \
		-i setup.py || die "can't patch setup.py"
}
