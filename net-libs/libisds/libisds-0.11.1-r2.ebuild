# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Client library for accessing ISDS Soap services"
HOMEPAGE="http://xpisar.wz.cz/libisds/"
SRC_URI="http://xpisar.wz.cz/${PN}/dist/${P}.tar.xz"
KEYWORDS="~amd64 ~mips ~x86"

LICENSE="LGPL-3"
SLOT="0"
IUSE="+curl debug doc nls openssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/expat
	dev-libs/libxml2
	curl? ( net-misc/curl[ssl] )
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
	openssl? ( dev-libs/openssl:= )
	!openssl? (
		app-crypt/gnupg
		app-crypt/gpgme:=
		dev-libs/libgcrypt:=
	)"
DEPEND="${RDEPEND}
	test? ( net-libs/gnutls )"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${PN}-0.11.1-Fix-building-with-libxml2-2.12.0.patch"
)

src_configure() {
	local myeconfargs=(
		--disable-fatalwarnings
		--disable-static
		$(use_with curl libcurl)
		$(use_enable curl curlreauthorizationbug)
		$(use_enable doc)
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable openssl openssl-backend)
		$(use_enable test)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
