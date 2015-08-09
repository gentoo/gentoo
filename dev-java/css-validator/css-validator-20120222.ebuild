# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="doc source"

# How to create the release tarball:
# $ export CVSROOT=":pserver:anonymous@dev.w3.org:/sources/public"
# $ cvs login
# $ cvs get 2002/css-validator
# $ cd 2002
# $ tar jcf css-validator-$(date "+%Y%m%d") css-validator --exclude=CVS

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Check Cascading Style Sheets (CSS) and (X)HTML documents with style sheets"
HOMEPAGE="http://jigsaw.w3.org/css-validator/DOWNLOAD.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="java-virtuals/servlet-api:2.5
	dev-java/velocity
	dev-java/commons-lang:2.1
	dev-java/tagsoup
	dev-java/jigsaw
	dev-java/xerces:2
	dev-java/htmlparser
	"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

EANT_BUILD_TARGET="jar war"
EANT_DOC_TARGET="javadoc"

S="${WORKDIR}/${PN}"

src_prepare() {
	rm -f tmp/*.jar
	mkdir -p "${S}/lib" || die "mkdir failed"

	epatch "${FILESDIR}/${P}-build.xml.patch"

	java-pkg_jarfrom --into lib/ servlet-api-2.5
	java-pkg_jarfrom --into lib/ velocity
	java-pkg_jarfrom --into lib/ commons-lang-2.1
	java-pkg_jarfrom --into lib/ tagsoup
	java-pkg_jarfrom --into lib/ jigsaw
	java-pkg_jarfrom --into lib/ xerces-2
	java-pkg_jarfrom --into lib/ htmlparser
}

src_install() {
	java-pkg_dojar "${PN}.jar"

	use source && java-pkg_dosrc org
	if use doc; then
		java-pkg_dojavadoc javadoc

		insinto "/usr/share/${PN}"
		doins "${PN}.war"
		einfo "Documentation for ${PN} has been installed as:"
		einfo "    /usr/share/${PN}/${PN}.war"
		einfo "You need to deploy this file using one of:"
		einfo "  * www-servers/tomcat"
		einfo "  * www-servers/resin"
	fi
}
