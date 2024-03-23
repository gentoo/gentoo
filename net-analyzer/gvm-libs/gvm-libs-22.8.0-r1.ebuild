# Copyright 1999-2024 Gentoo Authors
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
	>=app-crypt/gpgme-1.7.0:=
	>=dev-libs/glib-2.42:2
	>=dev-libs/hiredis-0.10.1:=
	dev-libs/libgcrypt:=
	dev-libs/libgpg-error
	>=dev-libs/libxml2-2.0:2
	>=net-libs/gnutls-3.2.15:=
	net-libs/libnet:1.1
	net-libs/libpcap
	>=net-libs/libssh-0.6.0:=
	>=sys-apps/util-linux-2.25.0
	sys-libs/libxcrypt:=
	>=sys-libs/zlib-1.2.8
	net-libs/paho-mqtt-c:1.3
	ldap? ( net-nds/openldap:= )
	radius? ( net-dialup/freeradius-client )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-vcs/git
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		app-text/xmltoman
		app-text/htmldoc
		dev-perl/CGI
		dev-perl/SQL-Translator
	)
	test? ( dev-libs/cgreen )
"

PATCHES=(
	# Fix bug 925932
	# See https://github.com/greenbone/gvm-libs/pull/811
	"${FILESDIR}"/gvm-libs-22.8.0-linking-math-library.patch
)

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Remove -Werror compiler flag | Bug: #909558
	sed -i -e "s/-Werror//" "${S}"/CMakeLists.txt || die
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
