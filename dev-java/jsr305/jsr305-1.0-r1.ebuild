# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

JAVA_PKG_IUSE="doc examples source test"
inherit eutils java-pkg-2 java-ant-2
MY_PN=jsr-305

DESCRIPTION="Reference implementation for JSR 305: Annotations for Software Defect Detection in Java"
SRC_URI="mirror://gentoo/${MY_PN}-source.tar.gz"
HOMEPAGE="http://code.google.com/p/jsr-305/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_PN}"

src_compile() {
	# create jar
	cd ri
	mkdir -p build/classes
	ejavac -sourcepath src/main/java -d build/classes $(find src/main/java -name "*.java") \
		|| die "Cannot compile sources"
	mkdir dist
	cd build/classes
	jar -cvf "${S}"/ri/dist/${PN}.jar javax || die "Cannot create JAR"

	# generate javadoc
	if use doc ; then
		cd "${S}"/ri
		mkdir javadoc
		javadoc -d javadoc -sourcepath src/main/java -subpackages javax \
			|| die "Javadoc creation failed"
	fi
}

src_install() {
	cd ri
	java-pkg_dojar dist/${PN}.jar

	if use examples; then
		dodir /usr/share/doc/${PF}/examples/
		cp -r "${S}"/sampleUses/* "${D}"/usr/share/doc/${PF}/examples/ || die "Could not install examples"
	fi

	if use source ; then
		cd "${S}"/ri/src/main/java
		java-pkg_dosrc javax
	fi

	if use doc ; then
		cd "${S}"/ri
		java-pkg_dojavadoc javadoc
	fi
}
