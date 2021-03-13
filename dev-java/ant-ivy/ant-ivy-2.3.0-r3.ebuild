# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc examples source test"

# Register this as a split-ant task.
WANT_SPLIT_ANT="true"

# Don't rewrite examples, that's bad.
JAVA_PKG_BSFIX_ALL="no"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="apache-ivy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="https://ant.apache.org/ivy/"
SRC_URI="mirror://apache/ant/ivy/${PV}/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"

# We cannot build tests yet as there is no org.apache.tools.ant.BuildFileTest packaged anywhere yet.
RESTRICT="test"

# SLOT to use for all bc dependencies.
BC_SLOT="1.50"

# There may be additional optional dependencies (commons-logging, commons-lang...)
CDEPEND="dev-java/jsch:0
	dev-java/bcpg:${BC_SLOT}
	dev-java/ant-core:0
	dev-java/bcpkix:${BC_SLOT}
	dev-java/bcprov:${BC_SLOT}
	dev-java/commons-vfs:0
	dev-java/jakarta-oro:2.0
	dev-java/commons-httpclient:3"

DEPEND=">=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit:0
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# This stuff needs removing.
	local CLEANUP=(
		doc/reports
		test/triggers
		doc/configuration
		test/repositories
		test/java/org/apache/ivy/core/settings/custom-resolver.jar
		src/example/chained-resolvers/settings/repository/test-1.0.jar
	)

	rm -rf "${CLEANUP[@]}" || die

	java-ant_rewrite-classpath
	mkdir lib || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_GENTOO_CLASSPATH="
	jsch
	bcpkix-${BC_SLOT}
	ant-core
	bcpg-${BC_SLOT}
	commons-vfs
	bcprov-${BC_SLOT}
	jakarta-oro-2.0
	commons-httpclient-3
"

EANT_BUILD_TARGET="/offline jar"

EANT_EXTRA_ARGS="-Dbuild.version=${PV} -Dbundle.version=${PV}"

src_test() {
	java-pkg_jar-from --into lib junit
	ANT_TASKS="ant-junit" eant "/offline test"
}

src_install() {
	java-pkg_dojar build/artifact/jars/ivy.jar
	java-pkg_register-ant-task

	if use doc; then
		java-pkg_dojavadoc build/doc/reports/api
		java-pkg_dohtml -r doc
	fi

	use examples && java-pkg_doexamples src/example
	use source && java-pkg_dosrc src/java/*
}
