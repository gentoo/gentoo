# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/fann/fann-2.2.0.ebuild,v 1.1 2012/05/08 18:18:55 bicatali Exp $

EAPI=4

inherit cmake-utils

MYP=FANN-${PV}-Source

DESCRIPTION="Fast Artificial Neural Network Library"
HOMEPAGE="http://leenissen.dk/fann/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples"

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MYP}"

PATCHES=( "${FILESDIR}"/${P}-examples.patch )

src_test() {
	cd examples
	emake CFLAGS="${CFLAGS} -I../src/include -L${BUILD_DIR}/src"
	LD_LIBRARY_PATH="${BUILD_DIR}/src" emake runtest
	emake clean
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
