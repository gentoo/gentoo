# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic systemd toolchain-funcs

MY_PN="openvas"
MY_DN="openvassd"

DESCRIPTION="Open Vulnerability Assessment Scanner"
HOMEPAGE="https://www.greenbone.net/en/"
SRC_URI="https://github.com/greenbone/openvas-scanner/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="cron extras"

DEPEND="
	app-crypt/gpgme:=
	dev-db/redis
	dev-libs/libgcrypt:=
	dev-libs/libksba
	>=net-analyzer/gvm-libs-10.0.1
	net-analyzer/net-snmp
	net-libs/gnutls:=
	net-libs/libpcap
	net-libs/libssh:=
"

RDEPEND="
	${DEPEND}"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	extras? ( app-doc/doxygen[dot]
		  app-doc/xmltoman
		  app-text/htmldoc
		  dev-perl/CGI
		  dev-perl/SQL-Translator
	)"

BUILD_DIR="${WORKDIR}/${MY_PN}-${PV}_build"
S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	# Install exec. to /usr/bin instead of /usr/sbin
	"${FILESDIR}/${P}-sbin.patch"
)

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Correct FHS/Gentoo policy paths for 6.0.1
	sed -i -e "s*/doc/openvas-scanner/*/doc/openvas-scanner-${PV}/*g" "$S"/src/CMakeLists.txt || die
	# QA-Fix | Remove !CLANG doxygen warnings for 6.0.1
	if use extras; then
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
}

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr"
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
	)
	# Add release hardening flags for 6.0.1
	append-cflags -Wno-format-truncation -Wformat -Wformat-security -D_FORTIFY_SOURCE=2 -fstack-protector
	append-ldflags -Wl,-z,relro -Wl,-z,now
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use extras; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
		HTML_DOCS=( "${BUILD_DIR}"/doc/generated/html/. )
	fi
	cmake_build rebuild_cache
}

src_install() {
	cmake_src_install

	dodir /etc/openvas
	insinto /etc/openvas
	newins "${FILESDIR}/${MY_DN}.gvm.conf" openvassd.conf

	insinto /etc/openvas
	doins "${FILESDIR}"/redis.conf.example

	dodir /etc/openvas/sysconfig
	insinto /etc/openvas/sysconfig
	doins "${FILESDIR}/${MY_DN}-daemon.conf"

	if use cron; then
		# Install the cron job if they want it.
		exeinto /etc/gvm
		doexe "${FILESDIR}/gvm-feed-sync.sh"
		fowners gvm:gvm /etc/gvm/gvm-feed-sync.sh

		insinto /etc/cron.d
		newins "${FILESDIR}"/gvm-feed-sync.cron gvm
	fi

	fowners -R gvm:gvm /etc/openvas

	newinitd "${FILESDIR}/${MY_DN}.init" "${MY_DN}"
	newconfd "${FILESDIR}/${MY_DN}-daemon.conf" "${MY_DN}"

	dodir /etc/logrotate.d
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_DN}.logrotate" "${MY_DN}"

	systemd_dounit "${FILESDIR}/${MY_DN}.service"

	# Set proper permissions on required files/directories
	keepdir /var/log/gvm
	fowners gvm:gvm /var/log/gvm
	keepdir /var/lib/openvas/{gnupg,plugins}
	fowners -R gvm:gvm /var/lib/openvas
}
