# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A swiss army knife for OSGi"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.REL.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"

CDEPEND="dev-java/libg:0
	dev-java/osgi-compendium:0
	dev-java/osgi-core-api:0
	dev-java/osgi-enterprise-api:0"

# Tests appear broken and cause a circular dependency.
# test? ( dev-java/bnd-junit:0 )
DEPEND="virtual/jdk:1.8
	${CDEPEND}
	test? ( dev-java/junit:4 )"

RDEPEND="virtual/jre:1.8
	${CDEPEND}"

S="${WORKDIR}/bnd-${PV}.REL/biz.aQute.${PN}"

EANT_BUILD_TARGET="build"

JAVA_ANT_REWRITE_CLASSPATH="true"

# Tests appear broken and cause a circular dependency.
RESTRICT="test"

src_prepare() {
	default
	# Move the correct build.xml into place, needed for testing.
	cp ../cnf/build.xml . || die

	# Remove bundled jar files.
	find . -name '*.jar' -delete > /dev/null

	if ! use test ; then
		rm -rf src/aQute/bnd/test || die "Failed to remove tests."
	fi
}

src_compile() {
	local extra_cp=""

	if use test ; then
		extra_cp=":$(java-pkg_getjars --build-only junit-4)"
	fi

	EANT_EXTRA_ARGS="-Dgentoo.classpath=$(java-pkg_getjars libg):$(java-pkg_getjars osgi-compendium):$(java-pkg_getjars osgi-core-api):$(java-pkg_getjars osgi-enterprise-api)${extra_cp}" \
		java-pkg-2_src_compile
}

EANT_TEST_GENTOO_CLASSPATH="junit-4,bnd-junit"
src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar generated/biz.aQute.${PN}.jar
}
