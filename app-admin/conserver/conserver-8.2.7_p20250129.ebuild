# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pam ssl-cert

COMMIT_HASH="290933b4a7964d56f74d2e3c61f7045c5e0d6bfe"
DESCRIPTION="Serial Console Manager"
HOMEPAGE="https://www.conserver.com"
SRC_URI="https://github.com/bstansell/${PN}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="BSD BSD-with-attribution"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="freeipmi ipv6 kerberos pam ssl tcpd"

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

DOCS=( CHANGES FAQ PROTOCOL README.md conserver/Sun-serial contrib/maketestcerts )

src_prepare() {
	default
	sed -e '/^INSTALL_PROGRAM/s:-s::' \
		-i {console,conserver,autologin,contrib/chat}/Makefile.in || die
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_with freeipmi)
		$(use_with ipv6)
		$(use_with kerberos gssapi)
		$(use_with pam)
		$(use_with ssl openssl)
		$(use_with tcpd libwrap)
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
	emake DESTDIR="${D}" exampledir="/usr/share/doc/${PF}/examples" install

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
