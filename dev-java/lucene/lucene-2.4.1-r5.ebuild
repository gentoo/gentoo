# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 verify-sig

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="https://lucene.apache.org"
SRC_URI="https://archive.apache.org/dist/${PN}/java/${P}-src.tar.gz
	verify-sig?	( https://archive.apache.org/dist/${PN}/java/${P}-src.tar.gz.asc )"

LICENSE="Apache-2.0"
SLOT="2.4"
KEYWORDS="~amd64"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/lucene.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-lucene )"

# Restricting to jdk:1.8 since it fails to build with openjdk-17
# BUILD FAILED
# /var/tmp/portage/dev-java/lucene-2.4.1-r3/work/lucene-2.4.1/build.xml:52: \
# rmic does not exist under Java 15 and higher,
# use rmic of an older JDK and explicitly set the executable attribute
DEPEND="
	dev-java/javacc:0
	virtual/jdk:1.8
	test? (
		>=dev-java/ant-1.10.14-r3:0[junit]
		dev-java/junit:0
	)"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}/lucene-2.4.1-skipFailingTest.patch"
	"${FILESDIR}/lucene-2.4.1-javacc.home.patch"
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean

	cat > build.properties <<-EOF || die
		ant.build.javac.source=$(java-pkg_get-source)
		ant.build.javac.target=$(java-pkg_get-target)
		javac.source=$(java-pkg_get-source)
		javac.target=$(java-pkg_get-target)
		javacc.home=${EPREFIX}/usr/share/javacc/lib/
		junit-location.jar=$(java-pkg_getjars --build-only junit)
	EOF

	rm docs/skin/images/instruction_arrow.png || die #: broken IDAT window length
	rm docs/images/instruction_arrow.png || die #: broken IDAT window length
}

src_compile() {
	eant javacc

	eant -Dversion=${PV} jar-core jar-demo
	use doc && eant -Dversion=${PV} javadocs-core javadocs-demo
}

src_test() {
	# we found that running tests with eant creates completely different output than
	# runnning with ant. no idea what exactly is causing that difference,
	ant test-core
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
