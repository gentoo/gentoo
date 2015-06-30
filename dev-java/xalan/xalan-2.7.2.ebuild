# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan/xalan-2.7.2.ebuild,v 1.1 2015/06/30 11:04:04 chewi Exp $

EAPI=5

# NOTE: Building the docs is much more hassle than it's worth. It
# requires com.sun.image.codec, which has long gone from JDKs, and
# Apache StyleBook, which is long dead though it is bundled here.

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 versionator

MY_PN="${PN}-j"
MY_PV="$(replace_all_version_separators _)"
MY_P="${MY_PN}_${MY_PV}"
SRC_DIST="${MY_P}-src.tar.gz"
BIN_DIST="${MY_P}-bin.zip"

DESCRIPTION="Apache's XSLT processor for transforming XML documents into HTML, text, or other XML document types"
HOMEPAGE="http://xalan.apache.org/"
SRC_URI="mirror://apache/${PN}/${MY_PN}/source/${SRC_DIST}
	doc? ( mirror://apache/${PN}/${MY_PN}/binaries/${BIN_DIST} )"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

CDEPEND="dev-java/javacup:0
	dev-java/bcel:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.3
	~dev-java/xalan-serializer-${PV}:${SLOT}"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.3
	doc? ( app-arch/unzip )"

EANT_GENTOO_CLASSPATH="bcel,javacup"
EANT_BUILD_TARGET="unbundledjar"
EANT_DOC_TARGET=""

JAVA_ANT_REWRITE_CLASSPATH="true"
S="${WORKDIR}/${MY_P}"

java_prepare() {
	# disable building of serializer.jar
	sed -i -e 's/depends="prepare,serializer.jar"/depends="prepare"/' \
		build.xml || die "sed build.xml failed"

	# remove bundled jars
	find -name "*.jar" -delete || die
	rm src/*.tar.gz || die
}

src_install() {
	java-pkg_newjar build/${PN}-unbundled.jar
	java-pkg_dolauncher ${PN} --main org.apache.xalan.xslt.Process
	java-pkg_register-dependency ${PN}-serializer

	dodoc NOTICE.txt readme.html
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/org
}
