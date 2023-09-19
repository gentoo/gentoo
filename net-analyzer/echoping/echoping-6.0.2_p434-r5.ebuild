# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Small program to test performances of remote servers"
HOMEPAGE="http://echoping.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~jsmolic/distfiles/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="gnutls http icp idn priority smtp ssl tos postgres ldap"
RESTRICT="test"

RDEPEND="
	idn? ( net-dns/libidn:= )
	ldap? ( net-nds/openldap:= )
	postgres? ( dev-db/postgresql:* )
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.3:= )
		!gnutls? (
			dev-libs/openssl:0=
		)
	)
"
DEPEND="
	${RDEPEND}
	>=sys-devel/libtool-2
"

REQUIRED_USE="gnutls? ( ssl )"
DOCS=( AUTHORS ChangeLog DETAILS NEWS README TODO )
PATCHES=(
	"${FILESDIR}"/${PN}-6.0.2_p434-fix_implicit_declarations.patch
	"${FILESDIR}"/${PN}-6.0.2_p434-gnutls_certificate_type_set_priority.patch
	"${FILESDIR}"/${PN}-6.0.2_p434-gnutls_session.patch
	"${FILESDIR}"/${PN}-6.0.2_p434-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable http)  \
		$(use_enable icp) \
		$(use_enable priority) \
		$(use_enable smtp) \
		$(use_enable tos) \
		$(use_with idn libidn) \
		$(usex gnutls $(use_with gnutls) $(use_with ssl)) \
		--config-cache \
		--disable-static \
		--disable-ttcp
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
