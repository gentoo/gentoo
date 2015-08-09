# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit ssl-cert eutils pam autotools

DESCRIPTION="Serial Console Manager"
HOMEPAGE="http://www.conserver.com/"
SRC_URI="http://www.conserver.com/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="kerberos pam ssl tcpd debug"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6g )
	pam? ( virtual/pam )
	tcpd? ( sys-apps/tcp-wrappers )
	debug? ( dev-libs/dmalloc )
	kerberos? (
		virtual/krb5
		net-libs/libgssglue
	)"
RDEPEND="${DEPEND}
	pam? ( >=sys-auth/pambase-20080219.1 )"

src_prepare() {
	# Apply patch to prevent package from stripping binaries
	epatch "${FILESDIR}"/${PN}-prestrip.patch

	# Apply patch to use custom dmalloc macro
	epatch "${FILESDIR}"/${P}-dmalloc.patch

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		$(use_with ssl openssl) \
		$(use_with pam) \
		$(use_with tcpd libwrap) \
		$(use_with debug dmalloc) \
		$(use_with kerberos gssapi) \
		--with-logfile=/var/log/conserver.log \
		--with-pidfile=/var/run/conserver.pid \
		--with-cffile=conserver/conserver.cf \
		--with-pwdfile=conserver/conserver.passwd \
		--with-master=localhost \
		--with-port=7782
}

src_install() {
	emake DESTDIR="${D}" exampledir="/usr/share/doc/${PF}/examples" install

	## create data directory
	dodir /var/consoles
	fowners daemon:daemon /var/consoles
	fperms 700 /var/consoles

	## add startup and sample config
	newinitd "${FILESDIR}"/conserver.initd-r1 conserver
	newconfd "${FILESDIR}"/conserver.confd conserver

	dodir /etc/conserver
	fperms 700 /etc/conserver
	insinto /etc/conserver
	newins "${S}"/conserver.cf/conserver.cf conserver.cf.sample
	newins "${S}"/conserver.cf/conserver.passwd conserver.passwd.sample

	## add docs
	dohtml conserver.html
	dodoc CHANGES FAQ PROTOCOL README TODO
	dodoc conserver/Sun-serial contrib/maketestcerts
	newdoc conserver.cf/conserver.cf conserver.cf.sample

	# Add pam config
	newpamd "${FILESDIR}"/conserver.pam-pambase conserver
}

pkg_postinst() {
	# Add certs if SSL use flag is enabled
	if use ssl && [ ! -f "${ROOT}"/etc/ssl/conserver/conserver.key ]; then
		install_cert /etc/ssl/conserver/conserver
	fi
}
