# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils autotools

DESCRIPTION="Small program to test performances of remote servers"
HOMEPAGE="http://echoping.sourceforge.net/"
SRC_URI="mirror://sourceforge/echoping/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="gnutls http icp idn priority smtp ssl tos postgres ldap"
RESTRICT="test"

RDEPEND="idn? ( net-dns/libidn )
	postgres? ( dev-db/postgresql )
	ldap? ( net-nds/openldap )
	ssl? (
		gnutls? ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( >=dev-libs/openssl-0.9.7d )
	)"
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2"

REQUIRED_USE="gnutls? ( ssl )"

DOCS=( README AUTHORS ChangeLog DETAILS NEWS TODO )

src_prepare() {
	# bug 279525:
	epatch "${FILESDIR}/${P}-gnutls.patch"

	epatch "${FILESDIR}/${P}-fix_implicit_declarations.patch"

	rm -f ltmain.sh
	cp /usr/share/libtool/config/ltmain.sh .
	local i
	for i in . plugins/ plugins/*/; do
		pushd "${i}" > /dev/null
		eautoreconf
		popd > /dev/null
	done
}

src_configure() {
	econf \
		--config-cache \
		--disable-ttcp \
		$(use_enable http)  \
		$(use_enable icp) \
		$(use_with idn libidn) \
		$(use_enable smtp) \
		$(use_enable tos) \
		$(use_enable priority) \
		$(usex gnutls $(use_with gnutls) $(use_with ssl))
}
