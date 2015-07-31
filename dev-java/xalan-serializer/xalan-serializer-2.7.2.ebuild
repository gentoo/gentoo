# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xalan-serializer/xalan-serializer-2.7.2.ebuild,v 1.3 2015/07/30 22:35:44 chewi Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 versionator

MY_PN="xalan-j"
MY_PV="$(replace_all_version_separators _)"
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="DOM Level 3 serializer from Apache Xalan, shared by Xalan and Xerces"
HOMEPAGE="http://xalan.apache.org/"
SRC_URI="mirror://apache/xalan/${MY_PN}/source/${MY_P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=virtual/jre-1.3"
DEPEND=">=virtual/jdk-1.3"

EANT_BUILD_TARGET="serializer.jar"
EANT_DOC_TARGET="serializer.javadocs"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	# kill all non-serializer sources to ease javadocs and dosrc
	find src/org/ -type f ! -path "src/org/apache/xml/serializer/*" -delete || die

	# remove bundled jars
	find -name "*.jar" -delete || die
	rm src/*.tar.gz || die
}

src_install() {
	java-pkg_dojar build/serializer.jar

	use doc && java-pkg_dojavadoc build/docs/apidocs
	use source && java-pkg_dosrc src/org
}
