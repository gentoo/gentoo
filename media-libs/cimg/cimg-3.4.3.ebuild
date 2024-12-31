# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="https://cimg.eu/ https://github.com/GreycLab/CImg"
SRC_URI="https://github.com/GreycLab/CImg/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CImg-v.${PV}"

LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

src_install() {
	doheader CImg.h
	dodoc README.txt

	use doc && dodoc -r html
	if use examples; then
		dodoc -r examples
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
