# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A complete implementation of the MS-NLMP documents as a GSSAPI mechanism"
HOMEPAGE="https://github.com/gssapi/gss-ntlmssp"
SRC_URI="https://github.com/gssapi/gss-ntlmssp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libunistring
	virtual/krb5
	net-fs/samba[client,winbind]
	dev-libs/openssl
"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	# install config file for kerberos
	sed -i 's,\$(get_libdir),/usr,g' "${S}"/examples/mech.ntlmssp
	insinto /etc/gss/mech.d/
	newins "${S}"/examples/mech.ntlmssp gssntlmssp.conf

	default
}
