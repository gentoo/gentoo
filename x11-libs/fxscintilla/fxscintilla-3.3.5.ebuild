# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils multilib

MY_PV=${PV//\./_}

DESCRIPTION="A free source code editing component for the FOX-Toolkit"
HOMEPAGE="http://www.nongnu.org/fxscintilla/"
SRC_URI="https://github.com/yetanothergeek/fxscintilla/archive/FXSCINTILLA-${MY_PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND="|| ( x11-libs/fox:1.6 x11-libs/fox:1.7 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-FXSCINTILLA-${MY_PV}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --libdir=/usr/$(get_libdir) --enable-shared
}

src_install () {
	emake DESTDIR="${D}" install

	dodoc README ChangeLog
	use doc && dohtml doc/*
}

pkg_postinst() {
	elog "FXScintilla is now built only against the highest available"
	elog "FOX-version you have installed."
}
