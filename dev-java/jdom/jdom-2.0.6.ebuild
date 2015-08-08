# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="source test"

#JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2

DESCRIPTION="Java API to manipulate XML data"
SRC_URI="http://www.jdom.org/dist/binary/${P}.zip"
HOMEPAGE="http://www.jdom.org"
LICENSE="JDOM"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 x86"

COMMON_DEP="dev-java/iso-relax
		dev-java/jaxen:1.1
		dev-java/xalan
		dev-java/xml-commons-external:1.4"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	app-arch/unzip
	test? ( dev-java/junit:0 )
	>=virtual/jdk-1.6"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack ./${P}-sources.jar
}

java_prepare() {
	find "${S}" -name '*.jar' -delete || die
	mkdir "${S}"/classes "${S}"/docs
}

src_compile() {
	find org -name "*.java" > "${T}"/src.list

	local cp="$(java-pkg_getjars iso-relax,jaxen-1.1,xalan,xml-commons-external-1.4)"
	if use test ; then
		cp="${cp}:junit.jar"
	else
		sed -i 's/PerfTest/PerfTemp/' "${T}"/src.list || die "Failed to rename PerfTest"
		sed -i '/test/Id' "${T}"/src.list || die "Failed to remove test classes"
		sed -i 's/PerfTemp/PerfTest/' "${T}"/src.list || die "Failed to rename PerfTest"
	fi

	ejavac -d "${S}"/classes -cp ${cp} "@${T}"/src.list

	# Disabled for the time being.
	# if use doc; then
	# 	ejavadoc -d "${S}"/docs -classpath ${cp} "@${T}"/src.list -quiet || die "javadoc failed"
	# fi

	cd "${S}"/classes
	jar -cf "${S}"/${PN}.jar * || die "failed to create jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar

	# Disabled for the time being.
	# if use doc; then
	# 	java-pkg_dojavadoc docs
	# fi

	dodoc README.txt LICENSE.txt || die
	use source && java-pkg_dosrc org
}
