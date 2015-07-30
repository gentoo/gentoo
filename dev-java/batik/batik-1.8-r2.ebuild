# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/batik/batik-1.8-r2.ebuild,v 1.1 2015/07/30 08:01:15 monsieurp Exp $

EAPI=5
JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Java based SVG toolkit"
HOMEPAGE="https://xmlgraphics.apache.org/batik/"
SRC_URI="http://apache.mirrors.ovh.net/ftp.apache.org/dist/xmlgraphics/${PN}/source/${PN}-src-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.8"
KEYWORDS="~amd64 ~x86 ~ppc ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc python tcl"

CDEPEND="dev-java/xalan:0
	dev-java/rhino:1.6
	dev-java/xml-commons-external:1.3
	dev-java/xmlgraphics-commons:2
	python? ( dev-java/jython:0 )
	tcl? ( dev-java/jacl:0 )
	dev-java/ant-core:0"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	xml-commons-external-1.3
	xmlgraphics-commons-2
	xalan
	rhino-1.6
"

java_prepare() {
	# bug #318323
	for file in build.xml contrib/rasterizertask/build.xml; do
		java-ant_xml-rewrite -f ${file} -c -e javadoc -a failonerror -v no -a maxmemory -v 512m
	done

	# Add some missing imports to avoid a compiling issue.
	# https://bugs.gentoo.org/show_bug.cgi?id=551952
	# https://issues.apache.org/jira/browse/BATIK-1123
	local imports=()
	imports+=(sources/org/apache/batik/script/jpython/JPythonInterpreterFactory.java)
	imports+=(sources/org/apache/batik/script/jacl/JaclInterpreterFactory.java)
	for import in ${imports[@]}; do
		einfo "Fixing missing import in ${import}"
		sed -i '23i import org.apache.batik.script.ImportInfo;' ${import} || die
		eend $?
	done

	cd lib || die
	rm -v *.jar build/*.jar || die
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

	# batik-all-1.8.jar is a all-in-one jar that contains all other jars.
	# We don't want to package it.
	# No actually we do. See bug 556062.
	# cd "${S}"/"${P}/lib" || die
	# rm -v ${PN}-all-${PV}.jar || die
}

src_install() {
	batik_unversion_jars() {
		for jar in batik-*.jar; do
			newj="${jar%-*}.jar"
			java-pkg_newjar ${jar} ${newj}
		done
	}

	# First unversion jars in ${P}/lib
	cd "${S}"/"${P}"/lib || die
	batik_unversion_jars

	# Then, only those in ${P}
	cd "${S}"/"${P}" || die
	batik_unversion_jars

	# Proceed with documentation installation
	cd "${S}" || die
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
