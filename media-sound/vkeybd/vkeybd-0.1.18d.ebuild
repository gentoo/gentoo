# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="A virtual MIDI keyboard for X"
HOMEPAGE="http://www.alsa-project.org/~iwai/alsa.html"
SRC_URI="http://ftp.suse.com/pub/people/tiwai/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE="alsa lash oss"

RDEPEND="alsa? ( media-libs/alsa-lib )
	>=dev-lang/tk-8.3
	lash? ( media-sound/lash )
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xf86bigfontproto
	x11-proto/bigreqsproto
	x11-proto/xextproto
	x11-proto/xcmiscproto"

S=${WORKDIR}/${PN}

pkg_setup() {
	TCL_VERSION=`echo 'puts [info tclversion]' | tclsh`

	vkeybconf="PREFIX=/usr"

	if use alsa; then
		vkeybconf+=" USE_ALSA=1"
		use oss || vkeybconf+=" USE_AWE=0 USE_MIDI=0"
	else
		vkeybconf+=" USE_ALSA=0 USE_AWE=1 USE_MIDI=1"
	fi

	use lash && vkeybconf+=" USE_LASH=1"

	vkeybconf+=" TCL_VERSION=${TCL_VERSION}"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.1.18c-desktop_entry.patch
}

src_compile() {
	tc-export CC
	emake ${vkeybconf} COPTFLAGS="${CFLAGS}" || die
}

src_install() {
	emake ${vkeybconf} DESTDIR="${D}" install-all || die
	dodoc ChangeLog README
}

pkg_postinst() {
	elog "The system-wide keymap is locale-sensitive now. A file"
	elog "vkeybdmap-\$LANG is searched in prior. For example, /etc/vkeybdmap-de"
	elog "can be used for the german locale. See the localization guide:"
	elog
	elog "https://www.gentoo.org/doc/en/guide-localization.xml"
}
