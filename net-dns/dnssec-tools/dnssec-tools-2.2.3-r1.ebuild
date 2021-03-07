# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 systemd

DESCRIPTION="Tools to ease the deployment of DNSSEC related technologies"
HOMEPAGE="https://dnssec-tools.org/"
SRC_URI="https://github.com/DNSSEC-Tools/DNSSEC-Tools/archive/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="static-libs"

RDEPEND="
	dev-lang/perl:=
	dev-perl/CGI
	dev-perl/Crypt-OpenSSL-Random
	dev-perl/Getopt-GUI-Long
	dev-perl/GraphViz
	dev-perl/MailTools
	dev-perl/Net-DNS
	dev-perl/Net-DNS-SEC
	dev-perl/XML-Simple"
DEPEND="${RDEPEND}"

S="${WORKDIR}/DNSSEC-Tools-${P}/${PN}"

PATCHES=( "${FILESDIR}"/${PN}-2.0-dtinitconf.patch )

src_prepare() {
	default
	sed -e '/^maninstall:/,+3s:$(MKPATH) $(mandir)/$(man1dir):$(MKPATH) $(DESTDIR)/$(mandir)/$(man1dir):' \
		-i Makefile.in || die
	sed -e 's:/usr/local/etc:/etc:g' \
		-e 's:/usr/local:/usr:g' \
		-i tools/donuts/donuts \
		-i tools/etc/dnssec-tools/dnssec-tools.conf \
		-i tools/scripts/genkrf || die
}

src_configure() {
	local myeconfargs=(
		--disable-bind-checks
		--without-validator
		--with-perl-build-args=INSTALLDIRS=vendor
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}"/rollerd.initd rollerd
	newconfd "${FILESDIR}"/rollerd.confd rollerd
	systemd_dounit "${FILESDIR}"/rollerd.service

	newinitd "${FILESDIR}"/donutsd.initd donutsd
	newconfd "${FILESDIR}"/donutsd.confd donutsd
	systemd_dounit "${FILESDIR}"/donutsd.service

	find "${ED}" -name "*.la" -delete || die
	readme.gentoo_create_doc
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="Please run 'dtinitconf' in order to set up the required
/etc/dnssec-tools/dnssec-tools.conf file

DNSSEC Validator has been split into net-dns/dnssec-validator
"
