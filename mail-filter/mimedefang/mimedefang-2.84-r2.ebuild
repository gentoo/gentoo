# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Antispam, antivirus and other customizable filters for MTAs with Milter support"
HOMEPAGE="http://www.mimedefang.org/"
SRC_URI="http://www.mimedefang.org/static/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clamav +poll test"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/defang
	acct-user/defang
	dev-perl/Digest-SHA1
	dev-perl/IO-stringy
	dev-perl/MailTools
	dev-perl/MIME-tools
	dev-perl/Unix-Syslog
	mail-filter/libmilter:=
	virtual/perl-MIME-Base64
	clamav? ( app-antivirus/clamav )
"

DEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Class
		dev-perl/Test-Most
	)
"

src_prepare() {
	eapply "${FILESDIR}/${PN}-2.72-ldflags.patch"
	eapply "${FILESDIR}/${PN}-tests.patch"
	eapply_user
}

src_configure() {
	local myeconfargs=(
		--with-user=defang
		$(use_enable poll)
		$(use_enable clamav)
		$(use_enable clamav clamd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_STRIP_FLAG="" install

	fowners defang:defang /etc/mail/mimedefang-filter
	fperms 644 /etc/mail/mimedefang-filter
	insinto /etc/mail/
	newins "${S}"/SpamAssassin/spamassassin.cf sa-mimedefang.cf

	keepdir /var/spool/{MD-Quarantine,MIMEDefang}
	fowners defang:defang /var/spool/{MD-Quarantine,MIMEDefang}
	fperms 700 /var/spool/{MD-Quarantine,MIMEDefang}

	keepdir /var/log/mimedefang

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	dodoc -r examples contrib
}

pkg_postinst() {
	elog "You can install Mail::SpamAssassin (mail-filter/spamassassin) and"
	elog "HTML::Parser (dev-perl/HTML-Parser) even after installing if you require"
	elog "them as they are loaded at run-time."
}
