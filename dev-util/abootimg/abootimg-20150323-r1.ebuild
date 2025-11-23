# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

COMMIT="1ebeb393252ab5aeed62e34bc439b6728444f06e"
DESCRIPTION="Manipulate Android boot images"
HOMEPAGE="https://gitlab.com/ajs124/abootimg"
SRC_URI="https://gitlab.com/ajs124/abootimg/-/archive/${COMMIT}/abootimg-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="sys-apps/util-linux"
RDEPEND="${DEPEND}"

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin abootimg
}
