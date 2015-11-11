# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 gnome2-utils fdo-mime

DESCRIPTION="GUI test tool and automation framework using accessibility framework"
HOMEPAGE="https://fedorahosted.org/dogtail/"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/gobject-introspection
	dev-python/pyatspi[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf:2[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libwnck:3[introspection]
	x11-base/xorg-server[xvfb]
	x11-apps/xinit
"
DEPEND="${DEPEND}"

src_prepare() {
	# Install docs in one place
	sed "s:doc/${PN}:doc/${PF}:" -i setup.py || die

	# Fix current user detection, upstream bug #46
	# Also, respect TMPDIR
	epatch "${FILESDIR}"/${PN}-0.9.0-get-user.patch

	# Upstream loads resources relative to __file__, which doesn't work with
	# gentoo's dev-lang/python-exec. So we need to add hard-coded paths.
	epatch "${FILESDIR}"/${PN}-0.9.0-gentoo-paths.patch
	sed -e "s:@EPREFIX_USR@:'${EPREFIX}/usr':" -i sniff/sniff || die "sed failed"

	distutils-r1_src_prepare
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
