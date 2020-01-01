# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake flag-o-matic toolchain-funcs user

DESCRIPTION="Greenbone vulnerability management libraries, previously named openvas-libraries"
HOMEPAGE="https://www.greenbone.net/en/"
SRC_URI="https://github.com/greenbone/gvm-libs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="extras ldap radius"

DEPEND="
	app-crypt/gpgme:=
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
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	extras? ( app-doc/doxygen[dot]
		  app-doc/xmltoman
		  app-text/htmldoc
		  dev-perl/CGI
		  dev-perl/SQL-Translator
	)"

PATCHES=(
	# Creating pid on build time instead of relying daemon!
	# QA fix for 10.0.1.
	"${FILESDIR}/${P}-pid.patch"
)

pkg_setup() {
	enewgroup gvm 495
	enewuser gvm 495 -1 /var/lib/gvm gvm
}

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
		"-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr"
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		$(usex ldap -DBUILD_WITHOUT_LDAP=0 -DBUILD_WITHOUT_LDAP=1)
		$(usex radius -DBUILD_WITHOUT_RADIUS=0 -DBUILD_WITHOUT_RADIUS=1)
	)
	# Add release hardening flags for 10.0.1
	append-cflags -Wformat -Wformat-security -D_FORTIFY_SOURCE=2 -fstack-protector
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

	# Set proper permissions on required files/directories
	keepdir /var/lib/gvm
	fowners -R gvm:gvm /var/lib/gvm
}
