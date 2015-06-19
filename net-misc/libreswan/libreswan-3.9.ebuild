# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/libreswan/libreswan-3.9.ebuild,v 1.1 2014/07/09 21:30:39 floppym Exp $

EAPI=5

inherit eutils systemd toolchain-funcs

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://download.libreswan.org/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libreswan/libreswan.git"
fi

DESCRIPTION="IPsec implementation for Linux, fork of Openswan"
HOMEPAGE="https://libreswan.org/"

LICENSE="GPL-2 BSD-4 RSA DES"
SLOT="0"
IUSE="caps curl dnssec ldap pam"

COMMON_DEPEND="
	dev-libs/gmp
	dev-libs/nspr
	caps? ( sys-libs/libcap-ng )
	curl? ( net-misc/curl )
	dnssec? ( net-dns/unbound net-libs/ldns )
	ldap? ( net-nds/openldap )
	pam? ( sys-libs/pam )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	dev-libs/nss
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/nss[utils(+)]
	sys-apps/iproute2
	!net-misc/openswan
	!net-misc/strongswan
"

src_prepare() {
	epatch_user
}

usetf() {
	usex "$1" true false
}

src_configure() {
	tc-export AR CC
	export INC_USRLOCAL=/usr
	export INC_MANDIR=share/man
	export FINALEXAMPLECONFDIR=/usr/share/doc/${PF}
	export FINALDOCDIR=/usr/share/doc/${PF}/html
	export INITSYSTEM=openrc
	export INC_RCDIRS=
	export INC_RCDEFAULT=/etc/init.d
	export USERCOMPILE=
	export USERLINK=
	export USE_DNSSEC=$(usetf dnssec)
	export USE_LIBCAP_NG=$(usetf caps)
	export USE_LIBCURL=$(usetf curl)
	export USE_LDAP=$(usetf ldap)
	export USE_XAUTHPAM=$(usetf pam)
}

src_compile() {
	emake programs
}

src_install() {
	emake DESTDIR="${D}" install
	sed -i -e '1s:python$:python2:' "${D}"/usr/libexec/ipsec/verify || die

	echo "include /etc/ipsec.d/*.secrets" > "${D}"/etc/ipsec.secrets
	fperms 0600 /etc/ipsec.secrets

	systemd_dounit "${FILESDIR}/ipsec.service"

	dodoc CHANGES README
	dodoc -r docs

	find "${D}" -type d -empty -delete || die
}

pkg_postinst() {
	local IPSEC_CONFDIR=${ROOT%/}/etc/ipsec.d
	if [[ ! -f ${IPSEC_CONFDIR}/cert8.db ]]; then
		ebegin "Setting up NSS database in ${IPSEC_CONFDIR}"
		certutil -N -d "${IPSEC_CONFDIR}" -f <(echo)
		eend $?
	fi
}
