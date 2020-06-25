# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="curses-based drawing tool"
HOMEPAGE="https://github.com/SyntheticDreams/NetPaint"
SRC_URI="https://github.com/SyntheticDreams/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MY_PN="NetPaint"
MY_P="${MY_PN}-${PV}"

RDEPEND="
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	mv netpaint.py netpaint || die
	sed -e 's#netpaint\.py#netpaint#g;' \
		-i setup.py || die "can't patch setup.py"
}
