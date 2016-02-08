# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Universal configuration library parser"
HOMEPAGE="https://github.com/vstakhov/libucl"
SRC_URI="https://github.com/vstakhov/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="lua +regex signatures static-libs urlfetch utils"
DEPEND="!!dev-libs/ucl
	lua? ( >=dev-lang/lua-5.1:= )
	signatures? ( dev-libs/openssl:0 )
	urlfetch? ( net-misc/curl )"
RDEPEND="${DEPEND}"

DOCS=( README.md doc/api.md )

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local myeconf=""
	use urlfetch && myeconf="--with-urls"
	econf \
		$(use_enable lua) \
		$(use_enable regex) \
		$(use_enable signatures) \
		$(use_enable utils) \
		${myeconf}
}

src_install() {
	default
	use lua && DOCS+=( doc/lua_api.md )
	# no .a's it seems
	use static-libs || find "${ED}" -name "*.la" -delete
}
