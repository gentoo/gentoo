# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/habak/habak-0.2.5-r1.ebuild,v 1.5 2012/08/03 06:22:33 xmw Exp $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="A simple but powerful tool to set desktop wallpaper"
HOMEPAGE="http://home.gna.org/fvwm-crystal/"
SRC_URI="http://download.gna.org/fvwm-crystal/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/imlib2[X]
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

# Skip into the src directory so we avoid a recursive make call that
# is going to break parallel make.
S="${WORKDIR}/${P}/src"

src_prepare() {
	sed -i \
		-e '/(LDFLAGS)/s:$: -lImlib2 -lm -lX11:' \
		-e 's:gcc:$(CC):' \
		"${S}"/Makefile || die "Makefile fixing failed"
}

src_compile() {
	emake CC="$(tc-getCC)" ${PN} || die "make failed"
}

src_install() {
	dobin ${PN} || die "dobin failed"

	cd "${WORKDIR}/${P}"
	dodoc ChangeLog README TODO "${FILESDIR}"/README.en || die "dodoc failed"
}
