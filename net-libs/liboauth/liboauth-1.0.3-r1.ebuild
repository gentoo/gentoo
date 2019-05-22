# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C library implementing the OAuth secure authentication protocol"
HOMEPAGE="http://liboauth.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 MIT )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86 ~x64-macos"
IUSE="bindist curl doc libressl +nss"

REQUIRED_USE="bindist? ( nss )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.1-doxygen-out-of-tree.patch
	"${FILESDIR}"/${PN}-1.0.3-openssl-1.1.patch
	"${FILESDIR}"/${PN}-1.0.3-openssl-1.1_2.patch
)

CDEPEND="
	curl? ( net-misc/curl )
	nss? ( dev-libs/nss
		curl? ( || (
			net-misc/curl[ssl,curl_ssl_nss]
			net-misc/curl[-ssl]
		) )
	)
	!nss? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
		curl? ( || (
			net-misc/curl[ssl,curl_ssl_openssl]
			net-misc/curl[-ssl]
		) )
	)
"

RDEPEND="${CDEPEND}"

DEPEND="
	${CDEPEND}
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
		media-fonts/freefont
	)
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable !curl curl)
		$(use_enable curl libcurl)
		$(use_enable nss)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use doc ; then
		# make sure fonts are found
		export DOTFONTPATH="${EPREFIX}"/usr/share/fonts/freefont-ttf
		emake dox
	fi
}

DOCS=( AUTHORS ChangeLog LICENSE.OpenSSL README )

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	find "${ED}" -name "*.la" -delete || die
}
