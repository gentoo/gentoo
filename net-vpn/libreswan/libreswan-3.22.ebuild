# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd toolchain-funcs

SRC_URI="https://download.libreswan.org/${P}.tar.gz"
KEYWORDS="amd64 ~ppc x86"

DESCRIPTION="IPsec implementation for Linux, fork of Openswan"
HOMEPAGE="https://libreswan.org/"

LICENSE="GPL-2 BSD-4 RSA DES"
SLOT="0"
IUSE="caps curl dnssec ldap pam seccomp selinux systemd test"

COMMON_DEPEND="
	dev-libs/gmp:0=
	dev-libs/libevent:0=
	dev-libs/nspr
	caps? ( sys-libs/libcap-ng )
	curl? ( net-misc/curl )
	dnssec? ( net-dns/unbound net-libs/ldns )
	ldap? ( net-nds/openldap )
	pam? ( sys-libs/pam )
	seccomp? ( sys-libs/libseccomp )
	selinux? ( sys-libs/libselinux )
	systemd? ( sys-apps/systemd:0= )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	dev-libs/nss
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	test? ( dev-python/setproctitle )
"
RDEPEND="${COMMON_DEPEND}
	dev-libs/nss[utils(+)]
	sys-apps/iproute2
	!net-misc/openswan
	!net-vpn/strongswan
	selinux? ( sec-policy/selinux-ipsec )
"

usetf() {
	usex "$1" true false
}

src_prepare() {
	sed -i -e 's:/sbin/runscript:/sbin/openrc-run:' initsystems/openrc/ipsec.init.in || die
	sed -i -e '/^install/ s/postcheck//' -e '/^doinstall/ s/oldinitdcheck//' initsystems/systemd/Makefile || die
	default
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
	export USE_LABELED_IPSEC=$(usetf selinux)
	export USE_LIBCAP_NG=$(usetf caps)
	export USE_LIBCURL=$(usetf curl)
	export USE_LINUX_AUDIT=$(usetf selinux)
	export USE_LDAP=$(usetf ldap)
	export USE_SECCOMP=$(usetf seccomp)
	export USE_SYSTEMD_WATCHDOG=$(usetf systemd)
	export SD_WATCHDOGSEC=$(usex systemd 200 0)
	export USE_XAUTHPAM=$(usetf pam)
	export DEBUG_CFLAGS=
	export OPTIMIZE_CFLAGS=
	export WERROR_CFLAGS=
}

src_compile() {
	emake all
	emake -C initsystems INITSYSTEM=systemd UNITDIR="$(systemd_get_systemunitdir)" all
}

src_test() {
	: # integration tests only that require set of kvms to be set up
}

src_install() {
	default
	emake -C initsystems INITSYSTEM=systemd UNITDIR="$(systemd_get_systemunitdir)" DESTDIR="${D}" install

	echo "include /etc/ipsec.d/*.secrets" > "${D}"/etc/ipsec.secrets
	fperms 0600 /etc/ipsec.secrets

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
