# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/easyneurons/easyneurons-2.3.ebuild,v 1.4 2012/04/13 18:06:26 ulm Exp $

EAPI="2"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="GUI neural network editor for neuroph"
HOMEPAGE="http://neuroph.sourceforge.net/"
SRC_URI="mirror://sourceforge/neuroph/neuroph_${PV}_nb.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEP="dev-java/colt:0
	dev-java/appframework:0
	dev-java/commons-collections:0
	dev-java/absolutelayout:0
	dev-java/jung:0
	dev-java/xstream:0
	~dev-java/neuroph-${PV}
	dev-java/javahelp:0
	dev-java/appframework:0"

RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/neuroph_${PV}_nb/${PN}"

java_prepare() {
	rm -R "${S}/../neuroph"
	mv lib/CopyLibs/*.jar "${T}"/ || die

	find "${WORKDIR}" -iname '*.jar' -delete
	find "${WORKDIR}" -iname '*.class' -delete
	mv "${T}"/org*.jar lib/CopyLibs/

	java-pkg_jar-from --into lib commons-collections \
		commons-collections.jar commons-collections-3.2.1.jar
	java-pkg_jar-from --into lib appframework appframework.jar
	java-pkg_jar-from --into lib/swing-app-framework appframework \
		appframework.jar appframework-1.0.3.jar
	java-pkg_jar-from --into lib jung jung.jar jung-1.7.6.jar
	java-pkg_jar-from --into lib absolutelayout \
		absolutelayout.jar
	java-pkg_jar-from --into lib xstream xstream.jar \
		xstream-1.3.1.jar
	java-pkg_jar-from --into lib javahelp jh.jar
	mkdir -p ../neuroph/dist
	java-pkg_jar-from --into ../neuroph/dist neuroph
}

src_compile() {
	eant -Dno.deps=True -Dreference.neuroph=lib/neuroph.jar \
		-Dlibs.swing-app-framework.classpath=lib/appframework.jar \
		-Dlibs.absolutelayout.classpath=lib/absolutelayout.jar jar
}

src_install() {
	java-pkg_newjar "dist/easyNeurons.jar"
	use source && java-pkg_dosrc src

	java-pkg_dolauncher ${PN} \
		--main org.neuroph.easyneurons.EasyNeuronsApplication

}
