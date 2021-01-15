# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools readme.gentoo-r1 systemd

DESCRIPTION="RSS downloader for Tranmission"
HOMEPAGE="https://github.com/1100101/Automatic"
SRC_URI="https://github.com/1100101/Automatic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="acct-user/automatic
	dev-libs/libxml2:2
	dev-libs/libpcre:3
	net-misc/curl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P^}"

DOC_CONTENTS="To run automatic you should move /etc/automatic.conf-sample
to /etc/automatic.conf and config it.\\n
If things go wrong, increase verbose level in /etc/conf.d/automatic
and check log file in /var/log/automatic/\\n"

src_prepare() {
	default

	# https://bugs.gentoo.org/426262
	mv configure.{in,ac} || die "rename failed"

	# Remove CFLAGS and CXXFLAGS defined by upstream
	sed -i  -e 's/CFLAGS="-Wdeclaration-after-statement -O3 -funroll-loops"/CFLAGS+=""/' \
		-e 's/CXXFLAGS="-O3 -funroll-loops"/CXXFLAGS+=""/' \
		configure.ac || die "sed for CXXFLAGS and CFLAGS failed"

	# tests fail with network-sandbox
	sed -i  -e '/check_PROGRAMS /s/http_test //' \
		-e '/check_PROGRAMS /s/prowl_test //' src/tests/Makefile.am \
		|| die "sed failed for Makefile.am"

	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}"/automatic.initd automatic
	newconfd "${FILESDIR}"/automatic.confd automatic
	systemd_dounit "${FILESDIR}"/automatic.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/automatic.logrotate automatic

	readme.gentoo_create_doc

	diropts -o automatic -g automatic -m 0700
	keepdir /var/log/automatic/
}

pkg_postinst() {
	readme.gentoo_print_elog
}
