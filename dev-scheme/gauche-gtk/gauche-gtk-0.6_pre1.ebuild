# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/gauche-gtk/gauche-gtk-0.6_pre1.ebuild,v 1.3 2015/06/13 09:40:53 zlogene Exp $

EAPI="4"

inherit autotools eutils

MY_P="${P/g/G}"
MY_PN="${PN/g/G}2"
PV_COMMIT="598828842a339a44c32ab8c16f5f9a77f3c1c799"

DESCRIPTION="GTK2 binding for Gauche"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="https://github.com/shirok/${MY_PN}/tarball/${PV_COMMIT} -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE="examples glgd nls opengl"
RESTRICT="test"

DEPEND="${RDEPEND}
	virtual/pkgconfig"
RDEPEND="x11-libs/gtk+:2
	dev-scheme/gauche
	opengl? (
		x11-libs/gtkglext
		dev-scheme/gauche-gl
	)"
S="${WORKDIR}/shirok-${MY_PN}-${PV_COMMIT:0:7}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-h2s-gdk-pixbuf.diff
	epatch "${FILESDIR}"/${PN}-gtk-lib.hints.diff
	epatch "${FILESDIR}"/${PN}-h2s-cpp.diff
	eautoconf
}

src_configure() {
	local myconf
	if use opengl; then
		if use glgd; then
			myconf="--enable-glgd"
			if use nls; then
				myconf="${myconf}-pango"
			fi
		else
			myconf="--enable-gtkgl"
		fi
	fi

	econf ${myconf}
}

src_compile() {
	emake stubs
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog README

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc examples/*.scm
		# install gtk-tutorial
		docinto examples/gtk-tutorial
		dodoc examples/gtk-tutorial/*
		if use opengl; then
			# install gtkglext
			dodoc -r examples/gtkglext
			if use glgd; then
				# install glgd
				dodoc -r examples/glgd
			fi
		fi
	fi
}
