# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit ssl-cert user

MY_P=${PN}${PV}

DESCRIPTION="A POP3 Server"
HOMEPAGE="http://www.eudora.com/products/unsupported/qpopper/index.html"
SRC_URI="ftp://ftp.qualcomm.com/eudora/servers/unix/popper/${MY_P}.tar.gz"

LICENSE="qpopper GPL-2 ISOC-rfc"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug gdbm mailbox pam ssl xinetd apop"

DEPEND="virtual/mta
	>=net-mail/mailbase-0.00-r8
	xinetd? ( virtual/inetd )
	gdbm? ( sys-libs/gdbm )
	pam? ( >=sys-libs/pam-0.72 )
	ssl? ( dev-libs/openssl:0 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1-parallel-build.patch
	"${FILESDIR}"/${PN}-4.1.0-glibc.patch #532254
)

pkg_setup() {
	use apop && enewuser pop
}

src_prepare() {
	default
	# Test dirs are full of binary craft. Drop it.
	rm -rf ./mmangle/test || die
	sed -i -e 's:-o popauth:& ${LDFLAGS}:' popper/Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable !xinetd standalone) \
		$(use_enable debug debugging)   \
		$(use_with ssl openssl)         \
		$(use_with gdbm)                \
		$(use_with pam pam pop3)        \
		$(use_enable apop apop /etc/pop.auth) \
		$(use_enable mailbox home-dir-mail Mailbox) \
		--disable-drac \
		--enable-shy \
		--enable-popuid=pop \
		--enable-log-login \
		--enable-specialauth \
		--enable-spool-dir=/var/spool/mail \
		--enable-log-facility=LOG_MAIL

	if ! use gdbm; then
		sed -i -e 's|#define HAVE_GDBM_H|//#define HAVE_GDBM_H|g' config.h || die "sed failed"
	fi
}

src_install() {
	if use apop; then
		dosbin popper/popauth
		fowners pop:root /usr/sbin/popauth
		fperms 4110 /usr/sbin/popauth
		doman man/popauth.8
	fi

	dosbin popper/popper
	doman man/popper.8

	insinto /etc
	doins "${FILESDIR}/qpopper.conf"

	if use ssl; then
		sed -i -e 's:^# \(set tls-server-cert-file\).*:\1 = /etc/mail/certs/cert.pem:' \
			   -e 's:^# \(set tls-support\).*$:\1 = stls:'\
			"${D}/etc/qpopper.conf"
	fi

	if use xinetd; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/qpopper.xinetd" pop-3
	else
		newinitd "${FILESDIR}/qpopper.init.d" qpopper
	fi

	HTML_DOCS="doc/LMOS-FAQ.html"
	einstalldocs
	dodoc doc/{Release.Notes,Changes}

	docinto rfc
	dodoc doc/rfc*.txt

	insinto /usr/share/doc/${PF}
	doins GUIDE.pdf
}

pkg_postinst () {
	if use ssl; then
		install_cert /etc/mail/certs/cert
		chown root:mail /etc/mail/certs
		chmod 660 /etc/mail/certs
	fi
	if use apop; then
		elog "To authenticate the users with APOP "
		elog "you have to follow these steps:"
		elog ""
		elog "1) initialize the authentication database:"
		elog "   # popauth -init"
		elog "2) new users can be added by root:"
		elog "   # popauth -user <user>"
		elog "   or removed:"
		elog "   # popauth -delete <user>"
		elog "   Other users can add themeselves or change their"
		elog "   password with the command popauth"
		elog "3) scripts or other non-interactive processes can add or change"
		elog "   the passwords with the following command:"
		elog "   # popauth -user <user> <password>"
		elog ""
	fi
}
