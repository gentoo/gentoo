# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN="${PN}-java"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Snappy compressor/decompressor for Java"
HOMEPAGE="https://github.com/xerial/snappy-java/"
SRC_URI="https://github.com/xerial/${MY_PN}/archive/${PV}.tar.gz -> ${PN}-java-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.1"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE=""

CDEPEND="dev-java/osgi-core-api:0
	app-arch/snappy"

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/junit:4
		dev-java/xerial-core:0
		dev-java/plexus-classworlds:0
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="osgi-core-api"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4,xerial-core,plexus-classworlds"
EANT_TEST_ANT_TASKS="ant-junit"

java_prepare() {
	cp "${FILESDIR}"/1.x-build.xml "${S}"/build.xml || die
	rm -r "${S}"/src/main/resources/org/xerial/snappy/native/ || die
	epatch "${FILESDIR}"/${PV}-unbundle-snappy.patch
	epatch "${FILESDIR}"/${PV}-gentoo.patch
}

src_compile() {
	emake
	java-pkg-2_src_compile
}

src_install() {
	local jniext=.so
	if [[ ${CHOST} == *-darwin* ]] ; then
		jniext=.jnilib
		# avoid install_name check failure
		install_name_tool -id @loader_path/libsnappyjava${jniext} \
			"${S}"/target/libsnappyjava${jniext}
	fi
	java-pkg_doso "${S}"/target/libsnappyjava${jniext}
	java-pkg_dojar "${S}/target/${PN}.jar"

	use source && java-pkg_dosrc "${S}"/src/main/java/*
	use doc && java-pkg_dojavadoc "${S}"/target/site/apidocs
}

src_test() {
	java-pkg-2_src_test
}
