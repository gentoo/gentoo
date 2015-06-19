# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-ivy/ant-ivy-2.3.0.ebuild,v 1.2 2013/07/10 11:51:04 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

# Register this as a split-ant task.
WANT_SPLIT_ANT="true"

# Don't rewrite examples, that's bad.
JAVA_PKG_BSFIX_ALL="no"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="apache-ivy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="http://ant.apache.org/ivy"
SRC_URI="mirror://apache/ant/ivy/${PV}/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"

# We cannot build tests yet as there is no org.apache.tools.ant.BuildFileTest packaged anywhere yet.
RESTRICT="test"

# There may be additional optional dependencies (commons-logging, commons-lang...)
COMMON_DEP="
	dev-java/ant-core:0
	dev-java/bcpg:0
	dev-java/bcpkix:0
	dev-java/bcprov:0
	dev-java/jakarta-oro:2.0
	dev-java/jsch:0
	dev-java/commons-httpclient:3
	dev-java/commons-vfs:0"

DEPEND="
	>=virtual/jdk-1.4
	test? ( dev-java/ant-junit )
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	rm -rf test/repositories
	rm -rf test/triggers
	rm -rf src/example/chained-resolvers/settings/repository/test-1.0.jar
	rm -rf test/java/org/apache/ivy/core/settings/custom-resolver.jar

	# Removing obsolete documentation.
	rm -rf doc/reports
	rm -rf doc/configuration

	java-ant_rewrite-classpath
	mkdir lib
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="ant-core,bcpg,bcpkix,bcprov,commons-vfs,jakarta-oro-2.0,jsch,commons-httpclient-3"

EANT_BUILD_TARGET="/offline jar"

EANT_EXTRA_ARGS="-Dbuild.version=${PV} -Dbundle.version=${PV}"

src_test() {
	java-pkg_jar-from --into lib junit
	ANT_TASKS="ant-junit" eant "/offline test"
}

src_install() {
	java-pkg_dojar "build/artifact/jars/ivy.jar"

	use doc && java-pkg_dojavadoc "build/doc/reports/api"
	use doc && dohtml -r "doc"
	use examples && java-pkg_doexamples "src/example"
	use source && java-pkg_dosrc src/java/*

	java-pkg_register-ant-task
}
