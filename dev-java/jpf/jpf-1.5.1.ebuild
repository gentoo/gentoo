# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Plugin Framework - a runtime engine that dynamically discovers and loads plugins"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip"
LICENSE="LGPL-2.1"

SLOT="1.5"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

S="${WORKDIR}"

COMMON_DEP="dev-java/commons-logging:0
	dev-java/ant-core"
DEPEND="app-arch/unzip
	>=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	java-ant_rewrite-classpath
	rm -fv lib/*.jar || die
	# needs some not yet packaged jxp dep, will add only on demand
	rm -rfv source-tools/org/java/plugin/tools/{docgen,ant/DocTask.java} || die
}

# doc target is name="-javadoc" and would need a patch, on demand
EANT_GENTOO_CLASSPATH="commons-logging,ant-core"

src_install() {
	java-pkg_dojar build/lib/jpf*.jar
	java-pkg_register-ant-task

	newdoc README.txt README || die
	dodoc changelog.txt || die
}
