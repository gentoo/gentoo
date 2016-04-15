# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

ESVN_REPO_URI="https://pbtech-vc.med.cornell.edu/public/svn/icb/trunk/goby"
EANT_GENTOO_CLASSPATH="commons-logging,commons-lang-2.1,commons-io-1,protobuf,fastutil,log4j,jsap,commons-configuration,commons-math-2"
EANT_GENTOO_CLASSPATH_EXTRA="lib/icb-utils.jar:lib/edu.mssm.crover.cli.jar:lib/JRI.jar:lib/dsiutils-1.0.12.jar"

JAVA_ANT_REWRITE_CLASSPATH="true"

#inherit java-pkg-2 java-ant-2 subversion
inherit java-pkg-2 java-ant-2

MY_P="${PN}_${PV}"

DESCRIPTION="A DNA sequencing data management framework"
HOMEPAGE="http://campagnelab.org/software/goby/"
SRC_URI="http://chagall.med.cornell.edu/goby/releases/archive/release-${MY_P}/${MY_P}-src.zip
	http://chagall.med.cornell.edu/goby/releases/archive/release-${MY_P}/${MY_P}-deps.zip"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
IUSE="+cpp"
KEYWORDS="~amd64 ~x86"

COMMON_DEPS="dev-java/commons-logging
	dev-java/commons-lang:2.1
	dev-java/commons-io:1
	dev-libs/protobuf[java]
	dev-java/fastutil:0
	dev-java/log4j
	dev-java/jsap
	dev-java/commons-configuration
	dev-java/commons-math:2"
DEPEND=">=virtual/jdk-1.6
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPS}
	cpp? ( ~sci-biology/goby-cpp-${PV} )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i '/sge/ d' build.xml || die
	java-pkg-2_src_prepare
}

src_install() {
	java-pkg_dojar goby*.jar
	java-pkg_dolauncher goby --jar goby.jar

	insinto /usr/share/${PN}
	doins -r python
	dodoc CHANGES.txt
}
