# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils qt4-r2

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
	dev-perl/Net-DNS-SEC
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
	epatch "${FILESDIR}"/${PN}-1.13-dtinitconf.patch
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

	newinitd "${FILESDIR}"/donutsd.initd donutsd
	newconfd "${FILESDIR}"/donutsd.confd donutsd

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
