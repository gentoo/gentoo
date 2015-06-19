# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/batik/batik-1.7-r3.ebuild,v 1.5 2013/03/27 09:31:08 ago Exp $

EAPI=4
JAVA_PKG_IUSE="doc"
inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java based SVG toolkit"
HOMEPAGE="http://xmlgraphics.apache.org/${PN}/"
SRC_URI="mirror://apache/xmlgraphics/${PN}/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="1.7"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc python tcl"

CDEPEND="dev-java/xalan:0
	dev-java/rhino:1.6
	dev-java/xml-commons-external:1.3
	python? ( dev-java/jython:0 )
	tcl? ( dev-java/jacl:0 )
	dev-java/ant-core"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

java_prepare() {
	java-ant_ignore-system-classes
	java-ant_rewrite-classpath contrib/rasterizertask/build.xml
	for file in build.xml contrib/rasterizertask/build.xml; do
		# bug #318323
		java-ant_xml-rewrite -f ${file} -c -e javadoc -a failonerror -v yes -a maxmemory -v 512m
	done

	cd lib
	rm -v *.jar build/*.jar || die

	java-pkg_jar-from xml-commons-external-1.3
	java-pkg_jar-from xalan
	java-pkg_jar-from rhino-1.6

	use python && java-pkg_jar-from jython
	use tcl && java-pkg_jar-from jacl
}

src_compile() {
	# Fails to build on amd64 without this
	if use amd64 ; then
		export ANT_OPTS="-Xmx1g"
	else
		export ANT_OPTS="-Xmx256m"
	fi

	eant jars all-jar $(use_doc)
	cd contrib/rasterizertask || die
	eant -Dgentoo.classpath="$(java-pkg_getjar ant-core ant.jar):../../classes" jar $(use_doc)
}

src_install() {
	#All-jar doesn't include ALL
	java-pkg_dojar ${P}/${PN}-*.jar

	cd ${P}/lib

	# needed because batik expects this layout:
	# batik.jar lib/*.jar
	# there are hardcoded classpaths in the manifest :(
	dodir /usr/share/${PN}-${SLOT}/lib/lib/
	for jar in batik*.jar
	do
		java-pkg_dojar ${jar}
		dosym ../${jar} /usr/share/${PN}-${SLOT}/lib/lib/${jar}
	done

	cd "${S}"
	dodoc README CHANGES
	use doc && java-pkg_dojavadoc ${P}/docs/javadoc

	# pwd fixes bug #116976
	java-pkg_dolauncher batik-${SLOT} --pwd "${EPREFIX}/usr/share/${PN}-${SLOT}/" \
		--main org.apache.batik.apps.svgbrowser.Main

	# To find these lsjar batik-${SLOT} | grep Main.class
	for launcher in ttf2svg slideshow svgpp rasterizer; do
		java-pkg_dolauncher batik-${launcher}-${SLOT} \
			--main org.apache.batik.apps.${launcher}.Main
	done

	# Install and register the ant task.
	java-pkg_dojar contrib/rasterizertask/build/lib/RasterizerTask.jar
	java-pkg_register-ant-task
}
