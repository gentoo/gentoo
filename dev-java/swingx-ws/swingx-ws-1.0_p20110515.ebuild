# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P="${PN}-2011_05_15-src"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Utilities and widgets to integrate Swing GUIs with web applications"
HOMEPAGE="https://java.net/projects/swingx-ws/"
SRC_URI="mirror://sourceforge/bt747/Development/${MY_P}.zip"
LICENSE="LGPL-2.1"
SLOT="bt747"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/commons-httpclient:3
	dev-java/jdom:1.0
	dev-java/json:0
	dev-java/jtidy:0
	dev-java/rome:0
	dev-java/swing-layout:1
	dev-java/swingx:1.6
	dev-java/swingx-beaninfo:0
	dev-java/xerces:2
	dev-java/xml-commons-external:1.4"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}/src"
JAVA_SRC_DIR="beaninfo java"
JAVA_GENTOO_CLASSPATH="commons-httpclient-3,jdom-1.0,json,jtidy,rome,swing-layout-1,swingx-1.6,swingx-beaninfo,xerces-2,xml-commons-external-1.4"

java_prepare() {
	java-pkg_clean "${WORKDIR}"

	# SwingWorker has been built-in since Java 6.
	find java -name "*.java" -exec sed -i -r "s:org\.jdesktop\.swingworker\.:javax.swing.:g" {} + || die

	# Fixes for newer swingx-beaninfo.
	sed -i "s:BeanInfoSupport:org.jdesktop.beans.\0:g" beaninfo/org/jdesktop/swingx/*.java || die
	find beaninfo -name "*.java" -exec sed -i -r "s:org\.jdesktop\.swingx\.(editors|BeanInfoSupport|EnumerationValue):org.jdesktop.beans.\1:g" {} + || die

	# GraphicsUtilities moved in later SwingX versions.
	sed -i "s:org\.jdesktop\.swingx\.graphics\.GraphicsUtilities:org.jdesktop.swingx.util.GraphicsUtilities:g" \
		java/org/jdesktop/swingx/mapviewer/AbstractTileFactory.java || die
}

src_compile() {
	java-pkg-simple_src_compile

	local DIR
	for DIR in ${JAVA_SRC_DIR}; do
		java-pkg_addres ${PN}.jar ${DIR}
	done
}
