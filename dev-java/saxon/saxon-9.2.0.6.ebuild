# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

JAVA_PKG_IUSE="doc source"

inherit versionator java-pkg-2 java-ant-2

MY_PV="$(replace_all_version_separators -)"

DESCRIPTION="A XSLT and XQuery Processor"
HOMEPAGE="http://saxon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}he${MY_PV}source.zip"

LICENSE="MPL-1.0"
SLOT="9"
KEYWORDS="amd64 ~arm ppc64 x86 ~x86-fbsd"

IUSE=""

# virtual/jdk slot for external javadoc
JDK_VER="6"
# dev-java/jdom slot for external javadoc
JDOM_VER="1.0"
# dev-java/dom4j slot
DOM4J_VER="1"

CDEPEND="dev-java/ant-core
	dev-java/dom4j:${DOM4J_VER}
	dev-java/jdom:${JDOM_VER}
	dev-java/xom"
RDEPEND=">=virtual/jre-1.${JDK_VER}
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.${JDK_VER}
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}"

# prepare eclass variables
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="javac javadoc"

src_unpack() {
	unpack ${A}

	### fedora-inspired remove

	# deadNET
	rm -rv net/sf/saxon/dotnet

	# Depends on XQJ (javax.xml.xquery)
	rm -rv net/sf/saxon/xqj

	# This requires a EE edition feature (com.saxonica.xsltextn)
	rm -v net/sf/saxon/option/sql/SQLElementFactory.java
}

java_prepare() {
	# <major>.<minor> version
	local version="$(get_version_component_range 1-2)"

	# generate build.xml with external javadoc links
	sed -e "s:@JDK@:${JDK_VER}:" \
		-e "s:@JDOM@:${JDOM_VER}:" \
		< "${FILESDIR}/${version}-build.xml" \
		> "${S}/build.xml" \
		|| die "build.xml generation failed!"

	# prepare creates the dir for properties
	eant prepare

	# properties
	cp -v \
		"${FILESDIR}/${version}-edition.properties" \
		"${S}/build/classes/edition.properties"
}

src_compile() {
	local gcp="$(java-pkg_getjars dom4j-${DOM4J_VER},jdom-${JDOM_VER},xom)"
	gcp="${gcp}:$(java-pkg_getjars --build-only ant-core)"
	eant -Dgentoo.classpath="${gcp}" jar $(use_doc)
}

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	java-pkg_dolauncher ${PN}${SLOT}-transform --main net.sf.saxon.Transform
	java-pkg_dolauncher ${PN}${SLOT}-query --main net.sf.saxon.Query

	java-pkg_register-ant-task

	use doc && java-pkg_dojavadoc build/api

	use source && java-pkg_dosrc src
}
