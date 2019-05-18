# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit versionator java-pkg-2 java-ant-2

MY_PV="$(replace_all_version_separators -)"

DESCRIPTION="A XSLT and XQuery Processor"
HOMEPAGE="http://saxon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}he${MY_PV}source.zip"

LICENSE="MPL-1.0"
SLOT="9"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CDEPEND="
	dev-java/xom:0
	dev-java/jdom:0
	dev-java/dom4j:1
	dev-java/ant-core"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}"

# prepare eclass variables
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="javac javadoc"

src_prepare() {
	default

	# Fedora-inspired removal.

	# deadNET.
	rm -rv net/sf/saxon/dotnet || die

	# Depends on XQJ (javax.xml.xquery).
	rm -rv net/sf/saxon/xqj || die

	# This requires a EE edition feature (com.saxonica.xsltextn).
	rm -v net/sf/saxon/option/sql/SQLElementFactory.java || die

	# <major>.<minor> version
	local version="$(get_version_component_range 1-2)"

	# generate build.xml with external javadoc links
	sed -e "s:@JDK@:1.6:" \
		-e "s:@JDOM@:1:" \
		< "${FILESDIR}/${version}-build.xml" \
		> "${S}/build.xml" \
		|| die "build.xml generation failed!"

	# prepare creates the dir for properties
	eant prepare

	# properties
	cp -v \
		"${FILESDIR}/${version}-edition.properties" \
		"${S}/build/classes/edition.properties" || die
}

src_compile() {
	local gcp="$(java-pkg_getjars dom4j-1,jdom,xom)"
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
