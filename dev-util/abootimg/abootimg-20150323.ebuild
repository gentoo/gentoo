# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT="1ebeb393252ab5aeed62e34bc439b6728444f06e"
DESCRIPTION="Manipulate Android boot images."
HOMEPAGE="https://gitlab.com/ajs124/abootimg"
SRC_URI="https://gitlab.com/ajs124/abootimg/repository/archive.tar.gz?ref=$COMMIT -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}-${COMMIT}"

src_install() {
	dobin abootimg
}
