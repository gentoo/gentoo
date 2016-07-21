# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils user

DESCRIPTION="A milter-based regular expression filter"
HOMEPAGE="http://www.benzedrine.cx/milter-regex.html"
SRC_URI="http://www.benzedrine.cx/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )"
DEPEND="${RDEPEND}
	virtual/yacc"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	emake CC="$(tc-getCC)" -f Makefile.linux milter-regex
}

src_install() {
	dobin milter-regex

	keepdir /var/run/milter-regex

	insinto /etc/mail
	newins rules milter-regex.conf

	newconfd "${FILESDIR}"/milter-regex-conf milter-regex
	newinitd "${FILESDIR}"/milter-regex-init milter-regex

	doman *.8
}

pkg_preinst() {
	enewgroup milter
	# mail-milter/spamass-milter creates milter user with this home directory
	# For consistency reasons, milter user must be created here with this home directory
	# even though this package doesn't need a home directory for this user (#280571)
	enewuser milter -1 -1 /var/lib/milter milter

	fowners milter:milter /var/run/milter-regex
}

pkg_postinst() {
	elog "If you're using Sendmail, you'll need to add this to your sendmail.mc:"
	elog "  INPUT_MAIL_FILTER(\`milter-regex', \`S=unix:/var/run/milter-regex/milter-regex.sock, T=S:30s;R:2m')"
	echo
	elog "If you are using Postfix, you'll need to add this to your main.cf:"
	elog "  smtpd_milters     = unix:/var/run/milter-regex/milter-regex.sock"
	elog "  non_smtpd_milters = unix:/var/run/milter-regex/milter-regex.sock"
}
