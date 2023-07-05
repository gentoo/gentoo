# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Greenbone Vulnerability Management (GVM) libraries"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/gvm-libs/"
SRC_URI="https://github.com/greenbone/gvm-libs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ldap test radius"
RESTRICT="!test? ( test )"

DEPEND="
	acct-user/gvm
	app-crypt/gpgme:=
	dev-libs/glib:2
	dev-libs/hiredis:=
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error
	dev-libs/libxml2
	dev-perl/UUID
	net-libs/gnutls:=
	net-libs/libnet:1.1
	net-libs/libpcap
	net-libs/libssh:=
	sys-apps/util-linux
	sys-libs/libxcrypt:=
	sys-libs/zlib
	dev-libs/paho-mqtt-c:1.3
	ldap? ( net-nds/openldap:= )
	radius? ( net-dialup/freeradius-client )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-vcs/git
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

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Remove -Werror compiler flag
	sed -i -e "s/-Werror//" "${S}"/CMakeLists.txt || die #909558
	# QA-Fix | Remove doxygen warnings for !CLANG
	if use doc; then
		if ! tc-is-clang; then
		   local f
		   for f in doc/*.in; do
			sed -i \
				-e "s*CLANG_ASSISTED_PARSING = NO*#CLANG_ASSISTED_PARSING = NO*g" \
				-e "s*CLANG_OPTIONS*#CLANG_OPTIONS*g" \
				"${f}" || die "couldn't disable CLANG parsing"
		   done
		fi
	fi

	#Remove tests that doesn't work in the network sandbox
	if use test; then
		sed -i 's/add_test (networking-test networking-test)/ /g' base/CMakeLists.txt || die
		sed -i 's/add_test (util-test util-test)/ /g' boreas/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DGVM_RUN_DIR=${EPREFIX}/var/lib/gvm"
		"-DBUILD_TESTS=$(usex test)"
		"-DBUILD_WITH_RADIUS=$(usex radius)"
		"-DBUILD_WITH_LDAP=$(usex ldap)"
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

	# Set proper permissions on required files/directories
	keepdir /var/lib/gvm
	if ! use prefix; then
		fowners -R gvm:gvm /var/lib/gvm
	fi
}
