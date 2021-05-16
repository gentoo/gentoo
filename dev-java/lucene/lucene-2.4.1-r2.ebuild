# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source test"
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="https://lucene.apache.org"
SRC_URI="https://archive.apache.org/dist/${PN}/java/${P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.4"
KEYWORDS="amd64 x86"

CDEPEND="
	dev-java/javacc:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	test? (
		dev-java/junit:0
		dev-java/ant-core:0
	)"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

src_prepare() {
	default
	java-pkg_clean
	sed -i -e '/-Xmax/ d' common-build.xml || die

	# Portage marks shese files as bogus for some reason.
	find . -type f -name instruction_arrow.png -exec rm -v {} \; || die
}

src_compile() {
	# regenerate javacc files just because we can
	# put javacc.jar on ant's classpath here even when <javacc> task
	# doesn't use it - it's to fool the <available> test, first time
	# it's useful not to have ignoresystemclasses=true...
	ANT_TASKS="ant-core javacc" \
		eant \
		-Djavacc.home="${EPREFIX}"/usr/share/javacc/lib \
		javacc
	ANT_TASKS="none" \
		eant \
		-Dversion=${PV} \
		jar-core \
		jar-demo \
		$(use_doc javadocs-core javadocs-demo)
}

src_test() {
	java-ant_rewrite-classpath common-build.xml
	EANT_GENTOO_CLASSPATH="junit ant-core" \
		ANT_TASKS="ant-junit" \
		eant \
		test-core
}

src_install() {
	einstalldocs
	java-pkg_newjar "build/${PN}-core-${PV}.jar" "${PN}-core.jar"
	java-pkg_newjar "build/${PN}-demos-${PV}.jar" "${PN}-demos.jar"

	if use doc; then
		dodoc -r docs
		java-pkg_dohtml -r build/docs/api
	fi
	use source && java-pkg_dosrc src/java/org
}
