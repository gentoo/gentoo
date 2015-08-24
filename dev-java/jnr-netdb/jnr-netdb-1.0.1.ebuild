# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Network services database access for java"
HOMEPAGE="https://github.com/wmeissner/jnr-netdb"
SRC_URI="https://github.com/wmeissner/jnr-netdb/tarball/${PV} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

COMMON_DEP=">=dev-java/jaffl-0.5.1:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}
	test?
	(
		dev-java/ant-junit4:0
		dev-java/hamcrest-core:0
		java-virtuals/jdk-with-com-sun:0
	)"

src_unpack() {
	unpack ${A}
	mv w* "${P}" || die
}

src_prepare() {
	mkdir -p lib
	find . -iname 'junit*.jar' -delete
	sed -i -e "s|run.test.classpath=|run.test.classpath=lib/hamcrest-core.jar:|g" nbproject/project.properties
	java-pkg_jar-from --into lib jaffl jaffl.jar
}

EANT_EXTRA_ARGS="-Dreference.jaffl.jar=lib/jaffl.jar \
	-Dproject.jaffl=\"${S}\" \
	-D\"already.built.${S}\"=true"

src_test() {
	java-pkg_jar-from --build-only --into lib/junit_4 junit-4 \
		junit.jar junit-4.5.jar
	java-pkg_jar-from --build-only --into lib hamcrest-core \
		hamcrest-core.jar
	sed -i -e \
	"s_\${file.reference.jffi-complete.jar}_$(java-pkg_getjars --build-only --with-dependencies jaffl)_" \
		nbproject/project.properties

	ANT_TASKS="ant-junit4 ant-nodeps" eant test \
		${EANT_EXTRA_ARGS} \
		-Djava.library.path="$(java-config -di jaffl)"
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/*
}
