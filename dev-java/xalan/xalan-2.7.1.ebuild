# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan/xalan-2.7.1.ebuild,v 1.12 2014/08/10 20:26:33 slyfox Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils versionator

MY_PN="${PN}-j"
MY_PV="$(replace_all_version_separators _)"
MY_P="${MY_PN}_${MY_PV}"
SRC_DIST="${MY_P}-src.tar.gz"
BIN_DIST="${MY_P}-bin.zip"
DESCRIPTION="Apache's XSLT processor for transforming XML documents into HTML, text, or other XML document types"
HOMEPAGE="http://xml.apache.org/xalan-j/index.html"
SRC_URI="mirror://apache/xml/${MY_PN}/source/${SRC_DIST}
	doc? ( mirror://apache/xml/${MY_PN}/binaries/${BIN_DIST} )"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc source"
COMMON_DEP="
	dev-java/javacup:0
	dev-java/bcel:0
	dev-java/xerces:2
	dev-java/xml-commons-external:1.3
	~dev-java/xalan-serializer-${PV}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	doc? ( app-arch/unzip )
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack "${SRC_DIST}"
	if use doc; then
		mkdir bin || die
		cd bin
		unpack ${BIN_DIST} || die
		cd ..
	fi
	cd "${S}"

	# disable building of serializer.jar
	sed -i -e 's/depends="prepare,serializer.jar"/depends="prepare"/' \
		build.xml || die "sed build.xml failed"

	# remove bundled jars
	rm -v lib/*.jar tools/*.jar || die
	cd lib
	java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
	java-pkg_jar-from xerces-2 xercesImpl.jar
	java-pkg_jar-from javacup javacup.jar java_cup.jar
	java-pkg_jar-from javacup javacup.jar runtime.jar
	java-pkg_jar-from bcel bcel.jar BCEL.jar

	cd "${S}"
	mkdir build && cd build
	java-pkg_jar-from xalan-serializer serializer.jar
}

# When version bumping Xalan make sure that the installed jar
# does not bundle .class files from dependencies
src_compile() {
	eant jar \
		-Dxsltc.bcel_jar.not_needed=true \
		-Dxsltc.runtime_jar.not_needed=true \
		-Dxsltc.regexp_jar.not_needed=true
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	# installs symlinks to the file in /usr/share/xalan-serializer
	java-pkg_dojar build/serializer.jar
	# and records it to package.env as if it belongs to this one's
	# classpath, for maximum possible backward compatibility
	java-pkg_regjar $(java-pkg_getjar xalan-serializer serializer.jar)

	java-pkg_dolauncher ${PN} --main org.apache.xalan.xslt.Process
	dohtml readme.html || die
	if use doc; then
		java-pkg_dohtml -r "${WORKDIR}"/bin/${MY_P}/docs/* || die
	fi
	use source && java-pkg_dosrc src/org
}
