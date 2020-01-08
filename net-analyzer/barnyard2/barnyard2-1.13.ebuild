# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Parser for Snort unified/unified2 files"
HOMEPAGE="https://github.com/firnsy/barnyard2 https://firnsy.com/projects"
SRC_URI="https://github.com/firnsy/barnyard2/archive/v2-${PV}.tar.gz -> ${P}-github.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug gre mpls mysql odbc postgres sguil"

DEPEND="
	net-libs/libpcap
	mysql? ( dev-db/mysql-connector-c:0= )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:* )
	sguil? ( dev-lang/tcl:* )
"
RDEPEND="
	${DEPEND}
"
DOCS="RELEASE.NOTES etc/barnyard2.conf doc/README* schemas/create_*"
S="${WORKDIR}/${PN}-2-${PV}"
PATCHES=(
	"${FILESDIR}"/${PN}-1.13-free.patch
	"${FILESDIR}"/${PN}-1.13-libdir.patch
	"${FILESDIR}"/${PN}-1.13-my_bool.patch
	"${FILESDIR}"/${PN}-1.13-odbc.patch
	"${FILESDIR}"/${PN}-1.13-pcap-1.9.0.patch
)

src_prepare() {
	default

	sed -i -e "s:^#config interface:config interface:" \
		"etc/barnyard2.conf" || die
	sed -i -e "s:^output alert_fast:#output alert_fast:" \
		"etc/barnyard2.conf" || die

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable gre) \
		$(use_enable mpls) \
		$(use_with mysql) \
		$(use_with odbc) \
		$(use_with postgres postgresql) \
		$(use_with sguil tcl) \
		--disable-aruba \
		--disable-ipv6 \
		--disable-mysql-ssl-support \
		--disable-prelude \
		--disable-static \
		--without-oracle
}

src_install () {
	default

	newconfd "${FILESDIR}/barnyard2.confd" barnyard2
	newinitd "${FILESDIR}/barnyard2.initd" barnyard2

	dodir /etc/barnyard2
	keepdir /var/log/barnyard2
	keepdir /var/log/snort/archive

	rm "${D}"/etc/barnyard2.conf || die
}

pkg_postinst() {
	elog "Configuration options can be set in /etc/conf.d/barnyard2."
	elog
	elog "An example configuration file can be found in /usr/share/doc/${PF}."
}
