# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd tmpfiles toolchain-funcs readme.gentoo-r1 optfeature

MY_DN="openvas"

DESCRIPTION="Open Vulnerability Assessment Scanner"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/openvas-scanner/"
SRC_URI="
	https://github.com/greenbone/openvas-scanner/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

SLOT="0"
LICENSE="GPL-2 GPL-2+"
KEYWORDS="amd64 ~x86"
IUSE="doc snmp test"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/gvm
	>=dev-db/redis-5.0.3
	>=dev-libs/glib-2.42:2
	>=dev-libs/json-glib-1.4.4
	>=net-libs/gnutls-3.2.15:=
	>=net-analyzer/gvm-libs-22.4
	net-libs/libpcap
	app-crypt/gpgme:=
	>=dev-libs/libgcrypt-1.6:=
	dev-libs/libgpg-error
	>=dev-libs/libksba-1.0.7
	>=net-libs/libssh-0.6.0:=
	dev-libs/libbsd
	snmp? ( net-analyzer/net-snmp:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=sys-devel/bison-2.5
	app-alternatives/lex
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		app-text/xmltoman
		app-text/htmldoc
		dev-perl/CGI
		dev-perl/SQL-Translator
		virtual/pandoc
	)
	test? ( dev-libs/cgreen )
"

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Remove -Werror compiler flag
	sed -i -e "s/-Werror//" "${S}"/CMakeLists.txt || die #909560
	# QA-Fix | Remove !CLANG doxygen warnings for 7.0.0
	if use doc; then
		if ! tc-is-clang; then
		   local f
		   for f in doc/*.in
		   do
			sed -i \
				-e "s*CLANG_ASSISTED_PARSING = NO*#CLANG_ASSISTED_PARSING = NO*g" \
				-e "s*CLANG_OPTIONS*#CLANG_OPTIONS*g" \
				"${f}" || die "couldn't disable CLANG parsing"
		   done
		fi
	fi

	#Remove tests that doesn't work in the network sandbox
	if use test; then
		sed -i 's/add_test (pcap-test pcap-test)/ /g' misc/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DSBINDIR=${EPREFIX}/usr/bin"
		"-DOPENVAS_FEED_LOCK_PATH=${EPREFIX}/var/lib/openvas/feed-update.lock"
		"-DOPENVAS_RUN_DIR=/run/ospd"
		"-DINSTALL_OLD_SYNC_SCRIPT=OFF"
		"-DBUILD_WITH_NETSNMP=$(usex snmp)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_build -C "${BUILD_DIR}" doxygen-full manual
	fi
	cmake_build rebuild_cache
	if use test; then
		cmake_build tests
	fi
}

src_install() {
	if use doc; then
		mv "${BUILD_DIR}"/doc/html "${BUILD_DIR}"/doc/html-manual || die
		local HTML_DOCS=(
			"${BUILD_DIR}"/doc/generated/html/.
			"${BUILD_DIR}"/doc/html-manual
		)
	fi
	cmake_src_install

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_DN}.logrotate" "${MY_DN}"

	# Set proper permissions on required files/directories
	keepdir /var/log/gvm
	if ! use prefix; then
		fowners gvm:gvm /var/log/gvm
	fi

	keepdir /var/lib/openvas/{gnupg,plugins}
	if ! use prefix; then
		fowners -R gvm:gvm /var/lib/openvas
	fi

	insinto /etc/openvas
	newins "${FILESDIR}/openvas.conf-22" openvas.conf

	systemd_newunit "${FILESDIR}/redis-openvas.service" redis-openvas.service
	newtmpfiles "${FILESDIR}/redis-openvas.tmpfiles" redis-openvas.conf

	insinto /etc/gvm
	doins config/redis-openvas.conf
	if ! use prefix; then
		fowners -R gvm:gvm /etc/gvm /etc/gvm/redis-openvas.conf
	fi

	fperms 0750 /etc/gvm
	fperms 0640 /etc/gvm/redis-openvas.conf

	newconfd "${FILESDIR}/redis-openvas.confd" redis-openvas
	newinitd "${FILESDIR}/redis-openvas.initd" redis-openvas

	if use prefix; then
		diropts -m0750
	else
		diropts -m0750 -o gvm -g gvm
	fi
	keepdir /var/lib/openvas/redis

	readme.gentoo_create_doc
}

pkg_postinst() {
	tmpfiles_process redis-openvas.conf
	optfeature "port scanner" net-analyzer/nmap
	readme.gentoo_print_elog
}
