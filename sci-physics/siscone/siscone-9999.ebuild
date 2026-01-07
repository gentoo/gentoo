# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hadron Seedless Infrared-Safe Cone jet algorithm"
HOMEPAGE="
	https://siscone.hepforge.org/
	https://gitlab.com/fastjet/siscone
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/fastjet/siscone"
else
	SRC_URI="https://siscone.hepforge.org/downloads/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="examples"

src_install() {
	cmake_src_install
	if use examples; then
		docinto examples
		dodoc examples/*.{cpp,h}
		docinto examples/events
		dodoc examples/events/*.dat
		docompress -x /usr/share/doc/${PF}/examples
	fi

	find "${ED}" -name '*.la' -delete || die
}
