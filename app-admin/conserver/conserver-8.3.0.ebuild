# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam ssl-cert verify-sig

DESCRIPTION="Serial Console Manager"
HOMEPAGE="https://conserver.com"
SRC_URI="
	https://github.com/bstansell/conserver/releases/download/v${PV}/${P}.tar.gz
	verify-sig? ( https://github.com/bstansell/conserver/releases/download/v${PV}/${P}.tar.gz.asc )
"

LICENSE="BSD BSD-with-attribution"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="freeipmi kerberos pam ssl tcpd"

DEPEND="
	virtual/libcrypt:=
	freeipmi? ( sys-libs/freeipmi )
	kerberos? (
		net-libs/libgssglue
		virtual/krb5
	)
	pam? ( sys-libs/pam )
	ssl? ( dev-libs/openssl:0= )
	tcpd? ( sys-apps/tcp-wrappers )
"
RDEPEND="${DEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-conserver )"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc

DOCS=( CHANGES FAQ PROTOCOL README.md conserver/Sun-serial contrib/maketestcerts )

src_configure() {
	local myconf=(
		$(use_with freeipmi)
		$(use_with kerberos gssapi)
		$(use_with pam)
		$(use_with ssl openssl)
		$(use_with tcpd libwrap)
		--with-ipv6
		--without-dmalloc
		--with-cffile=conserver/conserver.cf
		--with-logfile="${EPREFIX}"/var/log/conserver.log
		--with-master=localhost
		--with-pidfile="${EPREFIX}"/run/conserver.pid
		--with-port=7782
		--with-pwdfile=conserver/conserver.passwd
	)
	econf "${myconf[@]}"
}

src_test() {
	# hangs without -j1
	emake -j1 test
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PROGRAM=install exampledir="/usr/share/doc/${PF}/examples" install

	keepdir /var/consoles
	fowners daemon:daemon /var/consoles
	fperms 700 /var/consoles

	newinitd "${FILESDIR}"/conserver.initd-r1 conserver
	newconfd "${FILESDIR}"/conserver.confd-r1 conserver

	dodir /etc/conserver
	fperms 700 /etc/conserver
	insinto /etc/conserver
	newins "${S}"/conserver.cf/conserver.cf conserver.cf.sample
	newins "${S}"/conserver.cf/conserver.passwd conserver.passwd.sample

	einstalldocs
	docinto examples
	dodoc -r conserver.cf/samples/.

	if use pam; then
		newpamd "${FILESDIR}"/conserver.pam-pambase conserver
	fi
}

pkg_postinst() {
	if use ssl; then
		if [[ ! -f "${EROOT}"/etc/ssl/conserver/conserver.key ]]; then
			install_cert /etc/ssl/conserver/conserver
		fi
	fi
}
