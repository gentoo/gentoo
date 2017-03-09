# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="replace a desktop background with a movie or screensaver"
HOMEPAGE="http://tech.shantanugoel.com/projects/linux/shantz-xwinwrap"
SRC_URI="https://bazaar.launchpad.net/~shantanu-goel/xwinwrap/devel/tarball/4 -> ${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libXext
	x11-libs/libXrender"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/${PN}/devel"

src_unpack() {
	default
	mv * ./"${P}" || die
}

src_compile() {
	local cmd="$(tc-getCC) -Wall ${CFLAGS} ${PN}.c -o ${PN} ${LDFLAGS} \
		 $(pkg-config --libs x11 xext xrender)"
	ebegin $cmd
	$cmd || die
	eend $?
}

src_install() {
	dobin "${PN}"
}
