# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit autotools versionator java-pkg-2 java-pkg-simple

MY_P="${PN}-$(replace_version_separator 3 .Fork)"

DESCRIPTION="Fork of Tomcat Native that incorporates various patches"
HOMEPAGE="https://netty.io/wiki/forked-tomcat-native.html"
SRC_URI="https://github.com/netty/netty-tcnative/archive/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-libs/apr:1=
	dev-libs/openssl:0="

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	app-arch/unzip
	dev-java/maven-hawtjni-plugin:0"

S="${WORKDIR}/${PN}-${MY_P}"
JAVA_SRC_DIR="${S}/openssl-dynamic/src/main/java"
NATIVE_DIR="${S}/openssl-dynamic/src/main/native-package"

java_prepare() {
	cd "${NATIVE_DIR}" || die
	ln -sn ../c src || die
	ln -sn . project-template || die

	# Provides missing m4 files and Makefile.am template.
	unzip -n $(java-pkg_getjars --build-only maven-hawtjni-plugin) project-template/\* || die

	sed -i \
		-e "s:@PROJECT_NAME@:${PN}:g" \
		-e "s:@PROJECT_NAME_UNDER_SCORE@:${PN//-/_}:g" \
		-e "s:@PROJECT_SOURCES@:$(echo src/*.c):g" \
		Makefile.am || die

	# Avoid dummy version and tedious symlink.
	sed -i "s/-release @VERSION@/-avoid-version/g" configure.ac || die

	eautoreconf
}

src_configure() {
	cd "${NATIVE_DIR}" || die
	econf --with-apr=/usr/bin/apr-1-config --with-ssl=/usr
}

src_compile() {
	java-pkg-simple_src_compile
	emake -C "${NATIVE_DIR}"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_doso "${NATIVE_DIR}"/.libs/lib${PN}.so
	dodoc README.md
}
