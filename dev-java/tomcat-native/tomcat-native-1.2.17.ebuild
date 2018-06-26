# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2

DESCRIPTION="Allows Tomcat to use certain native resources for better performance"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/native/${PV}/source/${P}-src.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="static-libs test"

RDEPEND="dev-libs/apr:1=
	dev-libs/openssl:=
	>=virtual/jre-1.8"

DEPEND=">=virtual/jdk-1.8
	test? ( dev-java/ant-junit )"

S=${WORKDIR}/${P}-src

src_configure() {
	local myeconfargs=(
		--with-apr=/usr/bin/apr-1-config
		--with-ssl=/usr
	)

	cd native || die
	econf "${myeconfargs[@]}"
}

src_compile() {
	eant jar -f build.xml

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
	elog
	elog "Please report any bugs to https://bugs.gentoo.org/"
}
