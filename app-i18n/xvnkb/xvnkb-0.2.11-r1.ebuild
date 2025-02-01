# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic meson

DESCRIPTION="Vietnamese input keyboard for X"
HOMEPAGE="https://xvnkb.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="spell xft"

RDEPEND="x11-libs/libX11:=
	xft? ( x11-libs/libXft:= )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="xft? ( virtual/pkgconfig )"

src_prepare() {
	default
	cp "${FILESDIR}"/meson.build . ||die "Unable to move build system"
	cp "${FILESDIR}"/meson.options . ||die "Unable to move build system"
	cp "${FILESDIR}"/config.h.in . ||die "Unable to move build system"
}

src_configure() {
	append-cflags -std=gnu17

	local emesonargs=(
		$(meson_use spell spellcheck)
		$(meson_feature xft)
		-Dextstroke=true
	)

	meson_src_configure
}

src_install() {
	meson_src_install

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
