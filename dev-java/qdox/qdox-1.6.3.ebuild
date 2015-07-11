# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/qdox/qdox-1.6.3.ebuild,v 1.18 2015/07/11 09:22:21 chewi Exp $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2
DESCRIPTION="Parser for extracting class/interface/method definitions"
HOMEPAGE="http://qdox.codehaus.org/"
SRC_URI="http://repository.codehaus.org/com/thoughtworks/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="Apache-2.0"
SLOT="1.6"
KEYWORDS=" amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""

CDEPEND="dev-java/ant-core
	=dev-java/junit-3.8*"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
S=${WORKDIR}

src_compile() {
	# create jar
	mkdir -p build/classes
	ejavac -sourcepath . -d build/classes -classpath $(java-pkg_getjars ant-core,junit) \
		$(find . -name "*.java") || die "Cannot compile sources"
	mkdir dist
	cd build/classes
	jar -cvf "${S}/dist/${PN}.jar" com || die "Cannot create JAR"

	# generate javadoc
	if use doc ; then
		cd "${S}"
		mkdir javadoc
		javadoc -d javadoc -sourcepath . -subpackages com \
			-classpath $(java-pkg_getjars ant-core,junit)
	fi
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_register-ant-task

	use source && java-pkg_dosrc com
	use doc && java-pkg_dojavadoc javadoc
}
