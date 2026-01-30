# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tool for performing actions on an Active Directory domain"
HOMEPAGE="https://www.freedesktop.org/software/realmd/adcli/adcli.html"
SRC_URI="https://gitlab.freedesktop.org/realmd/adcli/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc netapi"

DEPEND="
	app-crypt/mit-krb5
	net-nds/openldap:=[sasl]
	netapi? ( net-fs/samba )"
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
	# builds its own policy, no selinux until policies are official
	local myconf="--disable-selinux-support"
	econf \
		${myconf} \
		$(use_enable doc) \
		$(use_enable netapi offline-join-support) \
		KRB5_CONFIG="${ESYSROOT}"/usr/bin/krb5-config
}
