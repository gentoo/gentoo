# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xerces/xerces-2.11.0.ebuild,v 1.10 2015/07/11 09:22:43 chewi Exp $

EAPI=4

JAVA_PKG_IUSE="doc examples source"

inherit eutils versionator java-pkg-2 java-ant-2

DIST_PN="Xerces-J"
SRC_PV="$(replace_all_version_separators _ )"
DESCRIPTION="The next generation of high performance, fully compliant XML parsers in the Apache Xerces family"
HOMEPAGE="http://xml.apache.org/xerces2-j/index.html"
SRC_URI="mirror://apache/${PN}/j/${DIST_PN}-src.${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# they are missing from the upstream tarball"
RESTRICT="test"

COMMON_DEP="
	dev-java/xml-commons-external:1.4
	>=dev-java/xml-commons-resolver-1.2:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4
	>=dev-java/xjavac-20110814:1"

S="${WORKDIR}/${PN}-${SRC_PV}"

java_prepare() {
	epatch "${FILESDIR}/${P}-build.xml.patch"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_ANT_TASKS="xjavac-1"
EANT_GENTOO_CLASSPATH="xml-commons-resolver,xml-commons-external-1.4"
EANT_DOC_TARGET="javadocs"
# known small bug - javadocs use custom taglets, which come as bundled jar in
# xerces-J-tools.${PV}.tar.gz. Should find the taglets source instead.
EANT_EXTRA_ARGS="-Dadditional.param="

src_install() {
	java-pkg_dojar build/xercesImpl.jar

	dodoc README NOTICE
	dohtml Readme.html

	use doc && java-pkg_dojavadoc build/docs/javadocs/xerces2
	use examples && java-pkg_doexamples samples
	use source && java-pkg_dosrc src/org
}
