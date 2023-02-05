# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools java-pkg-2 java-ant-2 verify-sig

DESCRIPTION="Allows Tomcat to use certain native resources for better performance"
HOMEPAGE="https://tomcat.apache.org/native-doc/"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/native/${PV}/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/tomcat/tomcat-connectors/native/${PV}/source/tomcat-native-${PV}-src.tar.gz.asc  )"
S=${WORKDIR}/${P}-src

KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="2"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/apr:1=
	dev-libs/openssl:0/3
	>=virtual/jre-1.8:*"

DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/ant-junit:0 )"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-tomcat-connectors )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/tomcat-connectors.apache.org.asc"

JAVA_ANT_REWRITE_CLASSPATH="yes"

PATCHES=(
	"${FILESDIR}"/${P}-slibtool.patch #778914
)

src_prepare() {
	default

	# Needed for the slibtool patch
	cd native || die
	sed -i 's/configure.in/configure.ac/' configure.in || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-apr="${EPREFIX}"/usr/bin/apr-1-config
		--with-ssl="${EPREFIX}"/usr
	)

	cd native || die
	econf "${myeconfargs[@]}"
}

src_compile() {
	eant jar

	cd native || die
	default
}

src_install() {
	java-pkg_newjar "dist/${P}.jar" "${PN}.jar"

	cd native || die
	default

	! use static-libs && find "${D}" -name '*.la' -delete || die
}

src_test() {
	java-pkg-2_src_test
}

pkg_postinst() {
	elog "For more information, please visit"
	elog "https://tomcat.apache.org/tomcat-9.0-doc/apr.html"
}
