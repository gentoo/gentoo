# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/postr/postr-0.13.1.ebuild,v 1.3 2014/07/23 15:19:03 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"

inherit eutils gnome2 python-single-r1

DESCRIPTION="Flickr uploader for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Postr"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-python/pygtk:2[${PYTHON_USEDEP}]
"

RDEPEND="${COMMON_DEPEND}
	dev-python/bsddb3[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gconf-python[${PYTHON_USEDEP}]
	dev-python/gtkspell-python[${PYTHON_USEDEP}]
	dev-python/libgnome-python[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	app-text/gnome-doc-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# Don't check for nautilus-python if we aren't installing the nautilus-2 extension
	sed -e 's:nautilus-python >= 0.6.1::' -i configure || die
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-nautilus-extension-dir="${EPREFIX}"/usr/share/nautilus-python/extensions
}

src_install() {
	gnome2_src_install
	python_fix_shebang "${ED}"

	rm -r "${ED}usr/share/nautilus-python" || die
}
