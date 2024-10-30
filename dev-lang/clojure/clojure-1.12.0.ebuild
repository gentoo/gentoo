# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SPEC_ALPHA_VER="0.5.238"        # https://github.com/clojure/spec.alpha/tags/
CORE_SPECS_ALPHA_VER="0.4.74"   # https://github.com/clojure/core.specs.alpha/tags/

TOOLS_NAMESPACE_VER="1.5.0"     # https://github.com/clojure/tools.namespace/tags/
JAVA_CLASSPATH_VER="1.1.0"      # https://github.com/clojure/java.classpath/tags/
TOOLS_READER_VER="1.4.0"        # https://github.com/clojure/tools.reader/tags/
TEST_GENERATIVE_VER="1.1.0"     # https://github.com/clojure/test.generative/tags/
DATA_GENERATORS_VER="1.1.0"     # https://github.com/clojure/data.generators/tags/
TEST_CHECK_VER="1.1.1"          # https://github.com/clojure/test.check/tags/

JAVA_PKG_IUSE="test"

inherit java-pkg-2

DESCRIPTION="General-purpose programming language with an emphasis on functional programming"
HOMEPAGE="https://clojure.org/
	https://github.com/clojure/clojure/"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${P}.tar.gz

	https://github.com/clojure/spec.alpha/archive/v${SPEC_ALPHA_VER}.tar.gz
		-> spec.alpha-${SPEC_ALPHA_VER}.tar.gz
	https://github.com/clojure/core.specs.alpha/archive/v${CORE_SPECS_ALPHA_VER}.tar.gz
		-> core.specs.alpha-${CORE_SPECS_ALPHA_VER}.tar.gz

	test? (
		https://github.com/clojure/tools.namespace/archive/v${TOOLS_NAMESPACE_VER}.tar.gz
			-> tools.namespace-${TOOLS_NAMESPACE_VER}.tar.gz
		https://github.com/clojure/java.classpath/archive/v${JAVA_CLASSPATH_VER}.tar.gz
			-> java.classpath-${JAVA_CLASSPATH_VER}.tar.gz
		https://github.com/clojure/tools.reader/archive/v${TOOLS_READER_VER}.tar.gz
			-> tools.reader-${TOOLS_READER_VER}.tar.gz
		https://github.com/clojure/test.generative/archive/v${TEST_GENERATIVE_VER}.tar.gz
			-> test.generative-${TEST_GENERATIVE_VER}.tar.gz
		https://github.com/clojure/data.generators/archive/v${DATA_GENERATORS_VER}.tar.gz
			-> data.generators-${DATA_GENERATORS_VER}.tar.gz
		https://github.com/clojure/test.check/archive/v${TEST_CHECK_VER}.tar.gz
			-> test.check-${TEST_CHECK_VER}.tar.gz
	)
"
S="${WORKDIR}/${PN}-${P}"

LICENSE="EPL-1.0 Apache-2.0 BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~x86-linux"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-java/ant-1.10.14-r3
"
RDEPEND="
	>=virtual/jre-1.8:*
"
DEPEND="
	>=virtual/jdk-1.8:*
"

PATCHES=(
	"${FILESDIR}/add-compile-spec-ant-build-target.patch"
)

DOCS=( changes.md CONTRIBUTING.md readme.txt )

src_prepare() {
	default
	java-pkg-2_src_prepare

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
	cp -r \
		../tools.namespace-${TOOLS_NAMESPACE_VER}/src/main/clojure/clojure/tools/* \
		src/clj/clojure/tools || die "Could not create symbolic link for tools-namespace"
	cp -r \
		../java.classpath-${JAVA_CLASSPATH_VER}/src/main/clojure/clojure/java/* \
		src/clj/clojure/java || die "Could not move java-classpath"
	cp -r \
		../tools.reader-${TOOLS_READER_VER}/src/main/clojure/clojure/tools/* \
		src/clj/clojure/tools || die "Could not move tools-reader"
	cp -r \
		../test.generative-${TEST_GENERATIVE_VER}/src/main/clojure/clojure/test/* \
		src/clj/clojure/test || die "Could not move test-generative"
	ln -rs \
		../data.generators-${DATA_GENERATORS_VER}/src/main/clojure/clojure/data/ \
		src/clj/clojure/data || die "Could not create symbolic link for data-generators"
	cp -r \
		../test.check-${TEST_CHECK_VER}/src/main/clojure/clojure/test/* \
		src/clj/clojure/test || die "Could not move test-check"

	eant -f build.xml test
}

src_install() {
	java-pkg_newjar "${PN}.jar"
	java-pkg_dolauncher "${PN}" --main clojure.main

	einstalldocs
}
