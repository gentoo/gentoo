# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A XSLT and XQuery Processor"
HOMEPAGE="https://www.saxonica.com/index.html https://saxon.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/saxon/Saxon-HE/$(ver_cut 1-2)/saxonhe${PV//./-}source.zip"

LICENSE="MPL-1.0"
SLOT="9"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"
IUSE="ant-task"

BDEPEND="app-arch/unzip"
CP_DEPEND="
	dev-java/dom4j:1
	dev-java/jdom:0
	dev-java/xom:0
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )"

JAVA_ENCODING="iso-8859-1"
JAVA_RESOURCE_DIRS="resources"

src_prepare() {
	java-pkg-2_src_prepare

	# Fedora-inspired removal.

	# deadNET.
	rm -rv net/sf/saxon/dotnet || die

	# Depends on XQJ (javax.xml.xquery).
	rm -rv net/sf/saxon/xqj || die

	# This requires a EE edition feature (com.saxonica.xsltextn).
	rm -v net/sf/saxon/option/sql/SQLElementFactory.java || die

	if use ant-task; then
		JAVA_GENTOO_CLASSPATH+="ant"
	else
		rm net/sf/saxon/ant/AntTransform.java || die
	fi

	mkdir resources || die
	cat > "resources/edition.properties" <<-EOF
		config=net.sf.saxon.Configuration
		platform=net.sf.saxon.java.JavaPlatform
	EOF
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN}${SLOT}-transform --main net.sf.saxon.Transform
	java-pkg_dolauncher ${PN}${SLOT}-query --main net.sf.saxon.Query
	use ant-task && java-pkg_register-ant-task
}
