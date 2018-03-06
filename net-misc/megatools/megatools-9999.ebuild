# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils git-r3

DESCRIPTION="Command line tools and C library for accessing Mega cloud storage"
HOMEPAGE="https://github.com/megous/megatools"
EGIT_REPO_URI="https://github.com/megous/megatools"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="fuse introspection libressl static-libs"

COMMON_DEPEND="dev-libs/glib:2
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl:0 )
	net-misc/curl
	fuse? ( sys-fs/fuse )
"
RDEPEND="${COMMON_DEPEND}
	net-libs/glib-networking[ssl]
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	app-text/asciidoc"

src_configure() {
	local myeconfargs=(
		--enable-shared
		--enable-docs-build
		--disable-maintainer-mode
		--disable-warnings
		--disable-glibtest
		$(use_enable static-libs static)
		$(use_enable introspection)
		$(use_with fuse)
	)
	autotools-utils_src_configure
}
