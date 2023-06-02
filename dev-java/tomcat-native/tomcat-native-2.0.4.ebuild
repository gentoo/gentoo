# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit autotools java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Allows Tomcat to use certain native resources for better performance"
HOMEPAGE="https://tomcat.apache.org/native-doc/"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/native/${PV}/source/${P}-src.tar.gz
	verify-sig? (
		https://downloads.apache.org/tomcat/tomcat-connectors/native/${PV}/source/tomcat-native-${PV}-src.tar.gz.asc
	)"
S=${WORKDIR}/${P}-src/native

KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="2"
IUSE="static-libs"

DEPEND="
	>=virtual/jdk-1.8:*
"
RDEPEND="
	dev-libs/apr:1=
	dev-libs/openssl:0/3
	>=virtual/jre-1.8:*
"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-tomcat-connectors )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/tomcat-connectors.apache.org.asc"

JAVA_RESOURCE_DIRS="../resources"
JAVA_SRC_DIR="../java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="../test"

PATCHES=(
	"${FILESDIR}"/tomcat-native-2.0.3-slibtool.patch #778914
)

DOCS=( ../{CHANGELOG.txt,NOTICE,README.txt} )

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p "${JAVA_RESOURCE_DIRS}/META-INF" || die
	sed -ne '/attribute name/s:^.*name="\(.*\)" value="\(.*\)".*$:\1\: \2:p' \
		../build.xml \
		| sed "s:\${version}:${PV}:" \
		> "${JAVA_RESOURCE_DIRS}/META-INF/MANIFEST.MF" || die
	default

	# Needed for the slibtool patch
	sed -i 's/configure.in/configure.ac/' configure.in || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-apr="${EPREFIX}"/usr/bin/apr-1-config
		--with-ssl="${EPREFIX}"/usr
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	java-pkg-simple_src_compile
	default
}

src_test() {
	JAVA_TEST_EXTRA_ARGS=( -Djava.library.path=".libs" )
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_doso .libs/*.so*
	dodoc -r ../docs
	! use static-libs && find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "For more information, please visit"
	elog "https://tomcat.apache.org/tomcat-9.0-doc/apr.html"
}
