# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="C++ template image processing toolkit"
HOMEPAGE="https://github.com/GreycLab/CImg"
EGIT_REPO_URI="https://github.com/GreycLab/CImg.git"
EGIT_COMMIT="v.${PV}"

LICENSE="CeCILL-2 CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

S="${WORKDIR}/${PN}-${PV}"

src_install() {
	doheader CImg.h
	dodoc README.txt

	use doc && dodoc -r html
	if use examples; then
		dodoc -r examples
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
