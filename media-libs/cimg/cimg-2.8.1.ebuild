# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="https://cimg.eu/ https://github.com/dtschump/CImg"
SRC_URI="https://github.com/dtschump/CImg/archive/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

S=${WORKDIR}/CImg-v.${PV}

src_install() {
	doheader CImg.h
	dodoc README.txt

	use doc && dodoc -r html
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
