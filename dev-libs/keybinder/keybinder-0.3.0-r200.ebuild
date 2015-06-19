# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/keybinder/keybinder-0.3.0-r200.ebuild,v 1.9 2012/11/28 09:48:45 ssuominen Exp $

EAPI=4

PYTHON_DEPEND="python? 2:2.6"

inherit eutils python

DESCRIPTION="A library for registering global keyboard shortcuts"
HOMEPAGE="http://kaizer.se/wiki/keybinder/"
SRC_URI="http://kaizer.se/publicfiles/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 x86"
IUSE="+introspection lua python"

RDEPEND=">=x11-libs/gtk+-2.20:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	introspection? ( dev-libs/gobject-introspection )
	lua? ( >=dev-lang/lua-5.1 )
	python? (
		>=dev-python/pygobject-2.15.3:2
		>=dev-python/pygtk-2.12
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS NEWS README"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	>py-compile
}

src_configure() {
	local myconf
	use lua || myconf='--disable-lua'

	econf \
		$(use_enable introspection) \
		$(use_enable python) \
		${myconf} \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	default
	prune_libtool_files --all
	dosym /usr/share/doc/${PF}/html/${PN} /usr/share/gtk-doc/html/${PN}
}

pkg_postinst() {
	use python && python_mod_optimize ${PN}
}

pkg_postrm() {
	use python && python_mod_cleanup ${PN}
}
