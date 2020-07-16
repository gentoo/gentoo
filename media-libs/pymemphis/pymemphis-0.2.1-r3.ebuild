# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

AT_M4DIR="build/autotools/"

inherit autotools python-single-r1

DESCRIPTION="Python bindings for the libmemphis library"
HOMEPAGE="http://gitorious.net/pymemphis"
SRC_URI="mirror://gentoo/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:2[${PYTHON_MULTI_USEDEP}]
	')
	media-libs/memphis"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-mainline

src_prepare() {
	default
	eautoreconf
	sed 's:0.1:0.2:g' -i pymemphis.pc.in || die
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
