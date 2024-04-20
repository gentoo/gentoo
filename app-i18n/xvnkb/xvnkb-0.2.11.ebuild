# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit toolchain-funcs

DESCRIPTION="Vietnamese input keyboard for X"
HOMEPAGE="https://xvnkb.sourceforge.net/"
SRC_URI="https://${PN}.sourceforge.net/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="spell xft"

RDEPEND="x11-libs/libX11:=
	xft? ( x11-libs/libXft:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="xft? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${PN}-cc.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default
	tc-export CC
}

src_configure() {
	# *not* autotools. Uses broken logic that assumes all the world is a bash
	bash ./configure \
		$(usex spell '' '--no-spellcheck') \
		$(usex xft '' '--no-xft') \
		--use-extstroke \
		|| die "./configure failed"
	[[ -f Makefile ]] || die "./configure failed to set an error code, but didn't create a Makefile either"
}

src_install() {
	dobin ${PN}
	dobin tools/${PN}_ctrl

	dolib.so ${PN}.so.${PV}
	dosym ${PN}.so.${PV} /usr/$(get_libdir)/${PN}.so

	einstalldocs
	dodoc -r doc/. scripts contrib
}

pkg_postinst() {
	elog "Remember to"
	elog "$ export LANG=en_US.UTF-8"
	elog "(or any other UTF-8 locale) and"
	elog "$ export LD_PRELOAD=/usr/$(get_libdir)/${PN}.so"
	elog "before starting X Window"
	elog "More documents are in ${EROOT}/usr/share/doc/${PF}"

	ewarn "Programs with suid/sgid will have LD_PRELOAD cleared"
	ewarn "You have to unset suid/sgid to use with ${PN}"
}
