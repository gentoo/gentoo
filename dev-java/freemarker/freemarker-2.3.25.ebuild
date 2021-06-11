# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="incubator-${PN}"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java tool to generate text output based on templates"
HOMEPAGE="http://freemarker.org/"
SRC_URI="https://github.com/apache/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="amd64 x86"

CP_DEPEND="dev-java/avalon-logkit:2.0
	dev-java/commons-logging:0
	dev-java/dom4j:1
	dev-java/jaxen:1.1
	dev-java/jython:2.7
	dev-java/log4j:0
	dev-java/rhino:1.6
	dev-java/slf4j-api:0
	dev-java/xalan:0
	java-virtuals/servlet-api:2.5"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.7"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.7
	dev-java/javacc:0"

S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}"/build.xml.patch
)

EANT_BUILD_TARGET="compile"
EANT_EXTRA_ARGS="-Ddeps.available=true"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_prepare() {
	default

	rm -rv \
	   src/main/java/freemarker/ext/jdom \
	   src/main/java/freemarker/ext/xml/_JdomNavigator.java \
	   src/main/java/freemarker/ext/beans/JRebelClassChangeNotifier.java || die

	sed -i \
		-e '/<ivy:cachepath/d' \
		-e 's/"ivy\.dep[^"]*"/"gentoo.classpath"/g' \
		-e "s:javacchome=\"[^\"]*\":javacchome=\"${EPREFIX%/}/usr/share/javacc/lib\":g" \
		build.xml || die

	java-pkg-2_src_prepare
}

src_install() {
	jar cf ${PN}.jar -C build/classes . || die
	java-pkg_dojar ${PN}.jar

	dodoc README
	use doc && java-pkg_dojavadoc build/api
}
