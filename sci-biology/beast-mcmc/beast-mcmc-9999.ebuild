# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

ESVN_REPO_URI="https://beast-mcmc.googlecode.com/svn/trunk/"

WANT_ANT_TASKS="ant-junit4"
EANT_GENTOO_CLASSPATH="colt,jdom-1.0,itext,junit-4,jebl,matrix-toolkits-java,commons-math-2,jdom-jaxen-1.0"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_ENCODING="latin1"
JAVA_PKG_BSFIX_NAME="build.xml build_BEAST_MCMC.xml build_coalsim.xml build_development.xml build_pathogen.xml build_release.xml build_treestat.xml build_vcs.xml"

inherit java-pkg-2 java-ant-2 eutils subversion

DESCRIPTION="Bayesian MCMC of Evolution & Phylogenetics using Molecular Sequences"
HOMEPAGE="https://github.com/beast-dev/beast-mcmc"
SRC_URI=""
#SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

# TODO: sys-cluster/mpijava
COMMON_DEPS="dev-java/colt:0
	dev-java/jdom:1.0
	dev-java/itext:0
	dev-java/junit:4
	dev-java/jebl:0
	dev-java/matrix-toolkits-java
	dev-java/commons-math:2
	dev-java/jdom-jaxen:1.0"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"

S="${WORKDIR}/beast_release_${PV//./_}"

src_prepare() {
	sed -i '/BEAST_LIB/ s|$BEAST|/usr/share/beast|' "${S}"/scripts/* || die
	cd lib
	rm -v colt.jar junit-*.jar itext-*.jar jdom.jar jebl.jar mtj.jar commons-math-*.jar || die
	java-pkg_jar-from jdom-1.0
	java-pkg_jar-from colt
	java-pkg_jar-from itext
	java-pkg_jar-from jebl
	java-pkg_jar-from matrix-toolkits-java
	java-pkg_jar-from commons-math-1
	java-pkg-2_src_prepare
}

src_compile() {
	eant dist_all_BEAST -f build_BEAST_MCMC.xml \
		-Dgentoo.classpath=$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH}):$(for i in lib/*.jar; do echo -n "$i:"; done) || die
	eant dist -f build_pathogen.xml \
		-Dgentoo.classpath=$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH}):$(for i in lib/*.jar; do echo -n "$i:"; done) || die
}

src_install() {
	java-pkg_dojar build/dist/*.jar dist/*.jar

	java-pkg_dolauncher beauti --jar beauti.jar --java_args '-Xms64m -Xmx256m'
#	java-pkg_dolauncher beauti --main dr.app.beauti.BeautiApp --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher beast --main dr.app.beast.BeastMain --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher loganalyser --main dr.app.tools.LogAnalyser --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher logcombiner --main dr.app.tools.LogCombiner --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher treeannotator --main dr.app.tools.TreeAnnotator --java_args '-Xms64m -Xmx256m'

	insinto /usr/share/${PN}
	doins -r examples || die
	dodoc NOTIFY doc/*.pdf
}

src_test() {
	eant junit -f build_BEAST_MCMC.xml \
		-Dgentoo.classpath=$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH}):$(for i in lib/*.jar; do echo -n "$i:"; done) || die
}
