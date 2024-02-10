# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A XSLT and XQuery Processor"
HOMEPAGE="https://www.saxonica.com/index.html https://saxon.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/saxon/Saxon-HE/$(ver_cut 1-2)/saxonhe${PV//./-}source.zip"

LICENSE="MPL-1.0"
SLOT="9"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CDEPEND="
	dev-java/ant-core:0
	dev-java/dom4j:1
	dev-java/jdom:0
	dev-java/xom:0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*"

BDEPEND="app-arch/unzip"

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
	local version="$(ver_cut 1-2)"

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
