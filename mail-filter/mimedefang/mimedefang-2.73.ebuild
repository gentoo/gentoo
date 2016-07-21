# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils user

DESCRIPTION="Antispam, antivirus and other customizable filtering for MTAs with Milter support"
HOMEPAGE="http://www.mimedefang.org/"
SRC_URI="http://www.mimedefang.org/static/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="clamav +poll"

DEPEND=">=dev-perl/MIME-tools-5.412
	dev-perl/IO-stringy
	virtual/perl-MIME-Base64
	dev-perl/Digest-SHA1
	clamav? ( app-antivirus/clamav )
	|| ( mail-filter/libmilter mail-mta/sendmail )"
RDEPEND="${DEPEND}"
RESTRICT="test"

pkg_setup() {
	enewgroup defang
	enewuser defang -1 -1 -1 defang
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.72-ldflags.patch
}

src_configure() {
	econf \
		--with-user=defang \
		$(use_enable poll) \
		$(use_enable clamav) \
		$(use_enable clamav clamd)
}

src_install() {
	emake DESTDIR="${D}" INSTALL_STRIP_FLAG="" install

	fowners defang:defang /etc/mail/mimedefang-filter
	fperms 644 /etc/mail/mimedefang-filter
	insinto /etc/mail/
	insopts -m 644
	newins "${S}"/SpamAssassin/spamassassin.cf sa-mimedefang.cf

	keepdir /var/spool/{MD-Quarantine,MIMEDefang}
	fowners defang:defang /var/spool/{MD-Quarantine,MIMEDefang}
	fperms 700 /var/spool/{MD-Quarantine,MIMEDefang}

	dodir /var/log/mimedefang
	keepdir /var/log/mimedefang

	newinitd "${FILESDIR}"/${PN}.init ${PN}
	newconfd "${FILESDIR}"/${PN}.conf ${PN}

	docinto examples
	dodoc examples/*
}
