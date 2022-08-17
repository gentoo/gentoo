# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="test"

inherit java-pkg-2 java-ant-2

SPEC_ALPHA_VER=0.3.218
CORE_SPECS_ALPHA_VER=0.2.62

TOOLS_NAMESPACE_VER=1.1.0
JAVA_CLASSPATH_VER=1.0.0
TOOLS_READER_VER=1.3.4
TEST_GENERATIVE_VER=1.0.0
DATA_GENERATORS_VER=1.0.0
TEST_CHECK_VER=1.1.1

DESCRIPTION="General-purpose programming language with an emphasis on functional programming"
HOMEPAGE="https://clojure.org/"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${P}.tar.gz
	https://github.com/clojure/spec.alpha/archive/v${SPEC_ALPHA_VER}.tar.gz -> spec.alpha-${SPEC_ALPHA_VER}.tar.gz
	https://github.com/clojure/core.specs.alpha/archive/v${CORE_SPECS_ALPHA_VER}.tar.gz -> core.specs.alpha-${CORE_SPECS_ALPHA_VER}.tar.gz
	test? (
		https://github.com/clojure/tools.namespace/archive/tools.namespace-${TOOLS_NAMESPACE_VER}.tar.gz
		https://github.com/clojure/java.classpath/archive/java.classpath-${JAVA_CLASSPATH_VER}.tar.gz
		https://github.com/clojure/tools.reader/archive/tools.reader-${TOOLS_READER_VER}.tar.gz
		https://github.com/clojure/test.generative/archive/test.generative-${TEST_GENERATIVE_VER}.tar.gz
		https://github.com/clojure/data.generators/archive/data.generators-${DATA_GENERATORS_VER}.tar.gz
		https://github.com/clojure/test.check/archive/v${TEST_CHECK_VER}.tar.gz -> test.check-${TEST_CHECK_VER}.tar.gz
	)
"

LICENSE="EPL-1.0 Apache-2.0 BSD"
SLOT="$(ver_cut 1-2)"

KEYWORDS="amd64 x86 ~x86-linux"

PATCHES=( "${FILESDIR}"/add-compile-spec-ant-build-target.patch )

RESTRICT="!test? ( test )"

RDEPEND=">=virtual/jre-1.8"
DEPEND=">=virtual/jdk-1.8"

S="${WORKDIR}"/${PN}-${P}

DOCS=( changes.md CONTRIBUTING.md readme.txt )

src_prepare() {
	default
	java-utils-2_src_prepare

	ln -rs \
		../spec.alpha-${SPEC_ALPHA_VER}/src/main/clojure/clojure/spec \
		src/clj/clojure/spec || die "Could not create symbolic link for spec-alpha"
	ln -rs \
		../core.specs.alpha-${CORE_SPECS_ALPHA_VER}/src/main/clojure/clojure/core/specs \
		src/clj/clojure/core/specs || die "Could not create symbolic link for core-specs-alpha"
}

src_compile() {
	eant -f build.xml jar
}

src_test() {
	ln -rs \
		../tools.namespace-tools.namespace-${TOOLS_NAMESPACE_VER}/src/main/clojure/clojure/tools \
		src/clj/clojure/tools || die "Could not create symbolic link for tools-namespace"
	mv \
		../java.classpath-java.classpath-${JAVA_CLASSPATH_VER}/src/main/clojure/clojure/java/* \
		src/clj/clojure/java || die "Could not move java-classpath"
	mv \
		../tools.reader-tools.reader-${TOOLS_READER_VER}/src/main/clojure/clojure/tools/* \
		src/clj/clojure/tools || die "Could not move tools-reader"
	mv \
		../test.generative-test.generative-${TEST_GENERATIVE_VER}/src/main/clojure/clojure/test/* \
		src/clj/clojure/test || die "Could not move test-generative"
	ln -rs \
		../data.generators-data.generators-${DATA_GENERATORS_VER}/src/main/clojure/clojure/data/ \
		src/clj/clojure/data || die "Could not create symbolic link for data-generators"
	mv \
		../test.check-${TEST_CHECK_VER}/src/main/clojure/clojure/test/* \
		src/clj/clojure/test || die "Could not move test-check"

	eant -f build.xml test
}

src_install() {
	java-pkg_newjar "${PN}.jar"
	java-pkg_dolauncher ${PN}-${SLOT} --main clojure.main

	einstalldocs
}
