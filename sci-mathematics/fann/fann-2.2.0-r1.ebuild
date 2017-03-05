# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

MY_P=FANN-${PV}-Source

DESCRIPTION="Fast Artificial Neural Network Library"
HOMEPAGE="http://leenissen.dk/fann/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

RDEPEND=""
DEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-examples.patch" )

src_test() {
	cd examples || die
	emake CFLAGS="${CFLAGS} -I../src/include -L${BUILD_DIR}/src"
	LD_LIBRARY_PATH="${BUILD_DIR}/src" emake runtest
	emake clean
}

src_install() {
	cmake-multilib_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
