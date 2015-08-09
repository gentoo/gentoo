# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="examples source doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Metapackage for mx4j"
HOMEPAGE="http://mx4j.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz
	doc? ( mirror://sourceforge/${PN}/${P}.tar.gz )"

LICENSE="GPL-2"
SLOT="3.0"

KEYWORDS="amd64 x86"

IUSE=""

CDEPEND="examples? (
		dev-java/bcel:0
		dev-java/log4j:0
		dev-java/commons-logging:0
		www-servers/axis:1
		java-virtuals/servlet-api:3.0
		dev-java/hessian:4.0
		dev-java/jython:2.7
		dev-java/gnu-jaf:1
		java-virtuals/javamail:0
	)
	dev-java/mx4j-core:3.0
	dev-java/mx4j-tools:3.0
	!<dev-java/mx4j-tools-3.0.1-r1
	"

RDEPEND="
	${CDEPEND}
	examples? ( >=virtual/jre-1.6 )"

# We always depend on a jdk to get the package.env created
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-new-hessian.patch"

	if use doc; then
		mkdir binary && cd binary
		unpack "${P}.tar.gz"
	fi

	if use examples; then
		cd "${S}/lib"
		java-pkg_jar-from bcel bcel.jar
		java-pkg_jar-from log4j
		java-pkg_jar-from commons-logging commons-logging.jar
		java-pkg_jar-from axis-1
		java-pkg_jar-from hessian-4.0
		java-pkg_jar-from jython-2.7 jython.jar
		java-pkg_jar-from gnu-jaf-1 activation.jar
		java-pkg_jar-from --virtual javamail mail.jar
		java-pkg_jar-from --virtual servlet-api-3.0 servlet-api.jar
	fi
}

src_compile() {
	cd build
	if use examples; then
		eant compile.examples
	fi
}

src_install() {
	dodoc README.txt RELEASE-NOTES-* || die

	if use examples; then
		java-pkg_dojar dist/examples/mx4j-examples.jar
		dodir /usr/share/doc/${PF}/examples
		cp -r src/examples/mx4j/examples/* "${D}usr/share/doc/${PF}/examples"
	fi

	use source && java-pkg_dosrc src/examples/mx4j

	if use doc; then
		local docdir="${WORKDIR}/${P}/binary/${P}/docs"
		java-pkg_dojavadoc "${docdir}/api"
		dohtml -r "${docdir}/images"
		dohtml "${docdir}"/{*.html,*.css}
	fi

	# Recording jars to get the same behaviour as before
	local jars="$(java-pkg_getjars mx4j-core-3.0,mx4j-tools-3.0)"
	for jar in ${jars//:/ }; do
		java-pkg_regjar "${jar}"
	done
}

pkg_postinst() {
	elog "Although this package can be used directly with java-config,"
	elog "ebuild developers should use mx4j-core and mx4j-tools directly."
}
