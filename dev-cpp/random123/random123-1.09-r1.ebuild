# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="library of counter-based random number generators (CBRNGs)"
HOMEPAGE="https://www.deshawresearch.com/resources_random123.html"
MY_P="${P^r}"
SRC_URI="https://www.deshawresearch.com/downloads/download_${PN}.cgi/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/include/Random123
	doins -r include/Random123/. examples/uniform.hpp
}
