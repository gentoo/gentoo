# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

[[ ${PV} = 9999* ]] && inherit git-r3 autotools

DESCRIPTION="Client library for accessing ISDS Soap services"
HOMEPAGE="http://xpisar.wz.cz/libisds/"
if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://repo.or.cz/${PN}.git"
else
	SRC_URI="http://xpisar.wz.cz/${PN}/dist/${P}.tar.xz"
	KEYWORDS="~amd64 ~mips ~x86"
fi

LICENSE="LGPL-3"
SLOT="0"
IUSE="+curl debug nls static-libs test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-crypt/gpgme
	dev-libs/expat
	dev-libs/libgcrypt:0=
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
	default
	[[ ${PV} = 9999* ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-fatalwarnings
		$(use_with curl libcurl)
		$(use_enable curl curlreauthorizationbug)
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable test)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
