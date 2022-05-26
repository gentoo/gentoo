# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

MY_PN="openvas"
MY_DN="openvassd"

DESCRIPTION="Open Vulnerability Assessment Scanner"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/openvas-scanner/"
SRC_URI="https://github.com/greenbone/openvas-scanner/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="doc snmp test"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/gvm
	app-crypt/gpgme:=
	dev-db/redis
	dev-libs/glib:2
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error
	dev-libs/libksba
	>=net-analyzer/gvm-libs-${PV}
	snmp? ( net-analyzer/net-snmp:= )
	net-libs/gnutls:=
	net-libs/libpcap
	net-libs/libssh:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		app-doc/xmltoman
		app-text/htmldoc
		dev-perl/CGI
		dev-perl/SQL-Translator
	)
	test? ( dev-libs/cgreen )
"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.1-disable-automagic-dep.patch
	"${FILESDIR}"/${PN}-7.0.1-fix-linking-with-lld.patch
	#qa fix for rpath
	"${FILESDIR}"/${PN}-20.8.1-rpath-qa-fix.patch
)

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Correct FHS/Gentoo policy paths for 7.0.0
	sed -i -e "s*/doc/openvas-scanner/*/doc/openvas-scanner-${PV}/*g" "${S}"/src/CMakeLists.txt || die
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
		"-DBUILD_WITH_SNMP=$(usex snmp)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
	fi
	cmake_build rebuild_cache
	if use test; then
		cmake_build tests
	fi
}

src_install() {
	if use doc; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc/generated/html/. )
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
	doins "${FILESDIR}/openvas.conf"
}
