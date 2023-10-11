# Copyright 2022 Gentoo Authors
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
IUSE="gnutls ssl"

REQUIRED_USE="
	|| ( ssl gnutls )
"
RDEPEND="
	ssl? (
		>=dev-libs/openssl-0.9.8:0=
	)
	gnutls? (
		>=net-libs/gnutls-3.5.8:0=
	)
"

DEPEND="
	${RDEPEND}
	dev-libs/jansson
"

PATCHES=(
	"${FILESDIR}/${PN}-1.15.3_multi_ssl_atools.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf

	if use ssl; then
		myconf=" --with-default-ssl=openssl"
	elif use gnutls; then
		myconf=" --with-default-ssl=gnutls"
	fi

	econf \
		--enable-multi-ssl \
		$(use_with gnutls) \
		$(use_with ssl openssl) \
		${myconf}
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
