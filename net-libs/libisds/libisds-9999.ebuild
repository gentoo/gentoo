# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

[[ ${PV} = 9999* ]] && inherit git-2 autotools
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"
inherit base eutils

DESCRIPTION="Client library for accessing ISDS Soap services"
HOMEPAGE="http://xpisar.wz.cz/libisds/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://xpisar.wz.cz/${PN}/dist/${P}.tar.xz"
	KEYWORDS="~amd64 ~mips ~x86"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE="+curl debug nls static-libs test"

COMMON_DEPEND="
	app-crypt/gpgme
	dev-libs/expat
	dev-libs/libgcrypt:0
	dev-libs/libxml2
	curl? ( net-misc/curl[ssl] )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="${COMMON_DEPEND}
	>=app-crypt/gnupg-2
"

DOCS=( NEWS README AUTHORS ChangeLog )

src_prepare() {
	base_src_prepare
	[[ ${PV} = 9999* ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-fatalwarnings \
		$(use_with curl libcurl) \
		$(use_enable curl curlreauthorizationbug) \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_enable test)
}

src_install() {
	base_src_install

	prune_libtool_files --all
}
