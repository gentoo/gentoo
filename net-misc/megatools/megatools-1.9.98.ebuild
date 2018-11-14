# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils

DESCRIPTION="Command line tools and C library for accessing Mega cloud storage"
HOMEPAGE="https://github.com/megous/megatools"
SRC_URI="https://github.com/megous/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/openssl:0=
	net-misc/curl
"
RDEPEND="${COMMON_DEPEND}
	net-libs/glib-networking[ssl]
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	app-text/asciidoc"

src_configure() {
	local myeconfargs=(
		--disable-maintainer-mode
		--disable-warnings
		--disable-glibtest
	)
	autotools-utils_src_configure
}
