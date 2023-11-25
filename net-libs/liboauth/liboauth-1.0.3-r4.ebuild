# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C library implementing the OAuth secure authentication protocol"
HOMEPAGE="https://liboauth.sourceforge.io/"
SRC_URI="mirror://sourceforge/project/${PN}/${P}.tar.gz"

LICENSE="|| ( GPL-2 MIT )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
IUSE="curl doc"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.1-doxygen-out-of-tree.patch
	"${FILESDIR}"/${PN}-1.0.3-openssl-1.1.patch
	"${FILESDIR}"/${PN}-1.0.3-openssl-1.1_2.patch
)

RDEPEND="
	>=dev-libs/openssl-3:=
	curl? (
		net-misc/curl
		|| (
			net-misc/curl[ssl,curl_ssl_openssl]
			net-misc/curl[-ssl]
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
		media-fonts/freefont
	)
"

DOCS=( AUTHORS ChangeLog LICENSE.OpenSSL README )

src_configure() {
	local myeconfargs=(
		# Upstream recommended NSS in the past for licencing reasons but w/ OpenSSL 3 that's
		# no longer a problem, plus curl >= 8.3 doesn't support NSS anymore.
		--disable-nss
		$(use_enable !curl curl)
		$(use_enable curl libcurl)
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

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	find "${ED}" -name "*.la" -delete || die
}
