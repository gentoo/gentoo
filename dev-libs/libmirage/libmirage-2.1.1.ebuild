# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmirage/libmirage-2.1.1.ebuild,v 1.3 2014/01/26 11:37:59 ago Exp $

EAPI="5"

CMAKE_MIN_VERSION="2.8.5"

inherit cmake-utils eutils fdo-mime toolchain-funcs versionator

DESCRIPTION="CD and DVD image access library"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0/9" # subslot = libmirage soname version
KEYWORDS="amd64 ~hppa x86"
IUSE="doc +introspection"

RDEPEND=">=app-arch/bzip2-1:=
	>=app-arch/xz-utils-5:=
	>=dev-libs/glib-2.24:2
	>=media-libs/libsamplerate-0.1:=
	>=media-libs/libsndfile-1.0:=
	sys-libs/zlib:=
	introspection? ( >=dev-libs/gobject-introspection-1.30 )"
DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use doc GTKDOC_ENABLED)
		$(cmake-utils_use introspection INTROSPECTION_ENABLED)
		-DPOST_INSTALL_HOOKS=OFF # avoid sandbox violation, #487304
	)
	cmake-utils_src_configure
}

src_install() {
	DOCS="AUTHORS README"
	cmake-utils_src_install
	prune_libtool_files --modules
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
