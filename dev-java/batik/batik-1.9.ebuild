# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-ant-2 epatch

DESCRIPTION="Java based SVG toolkit"
HOMEPAGE="https://xmlgraphics.apache.org/batik/"
SRC_URI="http://apache.mirrors.ovh.net/ftp.apache.org/dist/xmlgraphics/${PN}/source/${PN}-src-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.9"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc python tcl"

CDEPEND="
	tcl? ( dev-java/jacl:0 )
	python? ( dev-java/jython:2.7 )
	dev-java/xalan:0
	dev-java/rhino:1.6
	dev-java/ant-core:0
	dev-java/xmlgraphics-commons:2
	dev-java/xml-commons-external:1.3"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_GENTOO_CLASSPATH="
	xml-commons-external-1.3
	xmlgraphics-commons-2
	rhino-1.6
	xalan"

src_prepare() {
	default

	# See bug 318323.
	local file
	for file in build.xml contrib/rasterizertask/build.xml; do
		java-ant_xml-rewrite -f ${file} -c -e javadoc -a failonerror -v no -a maxmemory -v 512m
	done

	# See bug 628812.
	use tcl && epatch "${FILESDIR}/${P}-ImportInfo.patch"

	cd lib || die
	rm -v *.jar build/*.jar || die
	use python && java-pkg_jar-from jython-2.7
	use tcl && java-pkg_jar-from jacl
}

src_compile() {
	# Fails to build on amd64 without this
	export ANT_OPTS="-Xmx256m"
	use amd64 && export ANT_OPTS="-Xmx1g"

	eant jars all-jar $(use_doc)
	cd contrib/rasterizertask || die
	eant -Dgentoo.classpath="$(java-pkg_getjar ant-core ant.jar):../../classes" jar $(use_doc)
}

src_install() {
	batik_unversion_jars() {
		local jar
		for jar in batik-*.jar; do
			newj="${jar%-*}.jar"
			java-pkg_newjar ${jar} ${newj}
		done
	}

	# First unversion jars in ${P}/lib
	cd "${S}/${P}/lib" || die
	batik_unversion_jars

	# Then, only those in ${P}
	cd "${S}/${P}" || die
	batik_unversion_jars

	# Proceed with documentation installation
	cd "${S}" || die
	dodoc README CHANGES
	use doc && java-pkg_dojavadoc "${P}/docs/javadoc"

	# See bug #116976.
	java-pkg_dolauncher "batik-${SLOT}" \
		--pwd "${EPREFIX}/usr/share/${PN}-${SLOT}/" \
		--main org.apache.batik.apps.svgbrowser.Main

	# To find these lsjar batik-${SLOT} | grep Main.class
	local launcher
	for launcher in ttf2svg slideshow svgpp rasterizer; do
		java-pkg_dolauncher batik-${launcher}-${SLOT} \
			--main org.apache.batik.apps.${launcher}.Main
	done

	# Install and register the ant task.
	java-pkg_dojar contrib/rasterizertask/build/lib/RasterizerTask.jar
	java-pkg_register-ant-task
}
