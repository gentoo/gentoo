# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnssec-tools/dnssec-tools-2.0-r1.ebuild,v 1.1 2013/11/17 12:56:30 pacho Exp $

EAPI=4

inherit eutils qt4-r2 systemd

DESCRIPTION="tools to ease the deployment of DNSSEC related technologies"
HOMEPAGE="http://www.dnssec-tools.org/"
SRC_URI="http://www.dnssec-tools.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="dev-lang/perl
	dev-perl/Crypt-OpenSSL-Random
	dev-perl/Getopt-GUI-Long
	dev-perl/GraphViz
	dev-perl/MailTools
	dev-perl/Net-DNS
	dev-perl/XML-Simple"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e '/^maninstall:/,+3s:$(MKPATH) $(mandir)/$(man1dir):$(MKPATH) $(DESTDIR)/$(mandir)/$(man1dir):' \
		-i Makefile.in || die
	sed -e 's:/usr/local/etc:/etc:g' \
		-e 's:/usr/local:/usr:g' \
		-i tools/donuts/donuts \
		-i tools/etc/dnssec-tools/dnssec-tools.conf \
		-i tools/scripts/genkrf || die
	epatch "${FILESDIR}"/${PN}-2.0-dtinitconf.patch
}

src_configure() {
	econf \
		--disable-bind-checks \
		--without-validator \
		--with-perl-build-args=INSTALLDIRS=vendor \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/rollerd.initd rollerd
	newconfd "${FILESDIR}"/rollerd.confd rollerd
	systemd_dounit "${FILESDIR}"/rollerd.service

	newinitd "${FILESDIR}"/donutsd.initd donutsd
	newconfd "${FILESDIR}"/donutsd.confd donutsd
	systemd_dounit "${FILESDIR}"/donutsd.service

	prune_libtool_files
}

pkg_postinst() {
	einfo
	elog "Please run 'dtinitconf' in order to set up the required"
	elog "/etc/dnssec-tools/dnssec-tools.conf file"
	einfo
	elog "DNSSEC Validator has been split into net-dns/dnsval"
	einfo
}
