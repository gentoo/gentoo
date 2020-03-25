# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic toolchain-funcs

DESCRIPTION="Greenbone vulnerability management libraries, previously named openvas-libraries"
HOMEPAGE="https://www.greenbone.net/en/"
SRC_URI="https://github.com/greenbone/gvm-libs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="extras ldap radius"

DEPEND="
	acct-user/gvm
	app-crypt/gpgme:=
	dev-libs/glib
	dev-libs/hiredis
	dev-libs/libgcrypt:=
	dev-perl/UUID
	net-libs/gnutls:=
	net-libs/libssh:=
	sys-libs/zlib
	ldap? ( net-nds/openldap )
	radius? ( net-dialup/freeradius-client )"

RDEPEND="
	${DEPEND}"

BDEPEND="
	dev-vcs/git
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	extras? (
		app-doc/doxygen[dot]
		app-doc/xmltoman
		app-text/htmldoc
		dev-perl/CGI
		dev-perl/SQL-Translator
	)"

PATCHES=(
	# patch for missing gnutls linking https://github.com/greenbone/gvm-libs/issues/277
	"${FILESDIR}/${P}-gnutls.patch"
)

src_prepare() {
	cmake_src_prepare
	# QA-Fix | Remove doxygen warnings for !CLANG
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
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DGVM_PID_DIR=${EPREFIX}/var/lib/gvm"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use extras; then
		cmake_build -C "${BUILD_DIR}" doc
		cmake_build doc-full -C "${BUILD_DIR}" doc
	fi
	cmake_build rebuild_cache
}

src_install() {
	if use extras; then
		local HTML_DOCS=( "${BUILD_DIR}"/doc/generated/html/. )
	fi
	cmake_src_install

	# Set proper permissions on required files/directories
	keepdir /var/lib/gvm
	fowners -R gvm:gvm /var/lib/gvm
}
