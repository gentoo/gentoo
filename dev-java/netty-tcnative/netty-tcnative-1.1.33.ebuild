# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit autotools autotools-utils eutils java-pkg-2 java-pkg-simple

DESCRIPTION="Tomcat Native fork for Netty"

SLOT="0"
SRC_URI="https://github.com/netty/${PN}/archive/${PV}.zip"
HOMEPAGE="http://netty.io/wiki/forked-tomcat-native.html"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
IUSE=""

RDEPEND="dev-libs/apr:1
	dev-libs/openssl:=
	>=virtual/jre-1.7"

DEPEND=">=virtual/jdk-1.7
	${RDEPEND}"

S=${WORKDIR}/${P}/src/main

MY_S="${S}"

JAVA_SRC_DIR="java"

java_prepare() {
	rm c/os_win32* || die

	cd native-package || die

	mv ../c src || die

	SOURCES=$( ls src | tr "\n" " " ) || die

	echo "pkglib_LTLIBRARIES = lib${PN}.la
lib${PN/-/_}_la_SOURCES = ${SOURCES}
lib${PN/-/_}_la_LDFLAGS = -avoid-version -module -shared -export-dynamic" \
		>> Makefile.am || die

	sed -i -e "s|\[\@PROJECT_NAME\@\]|\[${PN}\]|" \
		-e "s|\@VERSION\@|${PV}|g" \
		-e "s|/error.c||" \
		-e "s|AC_CONFIG_HEADERS|#AC_CONFIG_HEADERS|" \
		-e 's|${CFLAGS="-O3 -Werror"}|LT_INIT([dlopen])|' \
		-e "s|disable-static|libtool shared disable-static|" \
		-e "s|WITH_OSX_UNIVERSAL|#WITH_OSX_UNIVERSAL|" \
		configure.ac || die

	AT_M4DIR="m4" eautoreconf
}
src_configure(){
	# Nasty but seems to be required for to find configure file
	S="${S}/native-package"
	autotools-utils_src_configure
	mv -v ${WORKDIR}/${P}_build/* ${S}/src || die
	S="${MY_S}"
}

src_compile() {
	java-pkg-simple_src_compile
	cd native-package/src || die
	emake
}

src_install() {
	java-pkg_newjar netty-tcnative.jar
	cd native-package/src || die
	emake DESTDIR="${D}" install
}
