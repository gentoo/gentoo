# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="JWT C Library"
HOMEPAGE="https://github.com/benmcollins/libjwt"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/benmcollins/libjwt"
else
	SRC_URI="https://github.com/benmcollins/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MPL-2.0"
SLOT="0"
# openssl / gnutls set which ssl implementations to use (build libjwt-ossl.so / libjwt-gnutls.so)
# IF openssl is enabled it will be the implementation used for libjwt.so
# gnutls will only be used for libjwt.so if openssl is disabled
IUSE="gnutls +openssl test"

REQUIRED_USE="
	|| ( gnutls openssl )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/jansson
	gnutls? (
		net-libs/gnutls:=
	)
	openssl? (
		dev-libs/openssl:=
	)
"

DEPEND="
	${RDEPEND}
	test? ( dev-libs/check )
"

PATCHES=(
	"${FILESDIR}/libjwt-1.15.3_multi_ssl_atools.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-multi-ssl
		$(use_with gnutls)
		$(use_with openssl)
		--with-default-ssl=$(usex openssl openssl gnutls)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
