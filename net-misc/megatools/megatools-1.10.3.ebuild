# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Command line tools and C library for accessing Mega cloud storage"
HOMEPAGE="https://megatools.megous.com"
SRC_URI="https://megatools.megous.com/builds/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:0=
	net-libs/glib-networking[ssl]
	net-misc/curl
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig
"

src_prepare() {
	default
	sed -i -e "/^AC_PROG_CC/ a AM_PROG_AR" configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--disable-warnings
}
