# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic readme.gentoo-r1 systemd

COMMIT="6301c30"

DESCRIPTION="RSS downloader for Tranmission"
HOMEPAGE="https://github.com/1100101/Automatic"
SRC_URI="https://github.com/1100101/Automatic/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="acct-group/automatic
	acct-user/automatic
	dev-libs/libxml2:2
	dev-libs/libpcre:3
	net-misc/curl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P^}"

# wrt #836740
PATCHES=( "${FILESDIR}"/"${P}"-util_test-header.patch )

DOC_CONTENTS="To run automatic you should move /etc/automatic.conf-sample
to /etc/automatic.conf and config it.\\n
If things go wrong, increase verbose level in /etc/conf.d/automatic
and check log file in /var/log/automatic/\\n"

src_prepare() {
	default

	# remove CFLAGS and CXXFLAGS defined by upstream
	sed -i  -e '/CFLAGS=/s/=".*"/+=""/' \
		-e '/CXXFLAGS=/s/=".*"/+=""/' \
		configure.ac || die "sed failed for configure.ac"

	# set version
	sed -i  -e "/SVN_REVISION/s|'\`git rev-parse --short HEAD\`'|${COMMIT}|" \
		-e "/LONG_VERSION_STRING/s|'\`git rev-parse --short HEAD\`'|${COMMIT}|" \
		src/Makefile.am || die "sed failed for src/Makefile.am"

	# provide test api keys for tests
	sed -i '/correct_key/s|""|"05b363d4561aaaa5c4c49bbb15639068b8cb6646"|' \
		src/tests/prowl_test.c || die "sed failed for prowl_test.c"
	# disable pushover tests
	sed -i '/check_PROGRAMS /s/ pushover_test//' src/tests/Makefile.am \
		|| die "sed failed for src/tests/Makefile.am"

	eautoreconf
}

src_configure() {
	filter-lto # wrt #861842

	econf
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
