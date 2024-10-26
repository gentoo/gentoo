# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tool for performing actions on an Active Directory domain"
HOMEPAGE="https://www.freedesktop.org/software/realmd/adcli/adcli.html"
SRC_URI="https://gitlab.freedesktop.org/realmd/adcli/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="doc"

DEPEND="
	app-crypt/mit-krb5
	net-nds/openldap:=[sasl]"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		app-text/docbook-xml-dtd:4.3
		app-text/xmlto
		dev-libs/libxslt
	)"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc) \
		KRB5_CONFIG="${ESYSROOT}"/usr/bin/krb5-config
}
