# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/expedite/expedite-1.7.10.ebuild,v 1.1 2015/03/17 02:28:52 vapier Exp $

EAPI="5"

EKEY_STATE="snap"

inherit enlightenment

DESCRIPTION="Performance and correctness test suite for Evas"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="BSD-2"
IUSE="directfb fbcon opengl X xcb"

RDEPEND=">=dev-libs/eina-${PV}
	>=media-libs/evas-${PV}[directfb?,fbcon?,opengl?,X?,xcb?]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	if use X ; then
		if use xcb ; then
			ewarn "You have enabled both 'X' and 'xcb', so we will use"
			ewarn "X as it's considered the most stable for evas."
		fi
		E_ECONF+=(
			--disable-xrender-xcb
			$(use_enable opengl opengl-x11)
		)
	elif use xcb ; then
		E_ECONF+=(
			--enable-xrender-xcb
		)
	else
		E_ECONF+=(
			--disable-gl-xlib
			--disable-software-xcb
			--disable-gl-xcb
		)
	fi
	E_ECONF+=(
		$(use_enable directfb)
		$(use_enable fbcon fb)
		$(use_enable X simple-x11)
		$(use_enable X software-x11)
		$(use_enable X xrender-x11)
	)
	enlightenment_src_configure
}
