# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple prefix

DMF="R-${PV}-201909161045"

DESCRIPTION="Ant Compiler Adapter for Eclipse Java Compiler"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV}.jar"

LICENSE="EPL-1.0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="4.13"
IUSE=""

CDEPEND="~dev-java/eclipse-ecj-${PV}:${SLOT}
	dev-java/ant-core:0"
RDEPEND="${CDEPEND}
	>=virtual/jre-11"
DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-11"

JAVA_GENTOO_CLASSPATH="ant-core,eclipse-ecj-${SLOT}"

src_prepare() {
	default

	# Remove everything but the Ant component.
	find org -type f ! -path "org/eclipse/jdt/internal/antadapter/*" ! -name "JDTCompilerAdapter.java" -delete || die

	rm build.xml || die
}

src_compile() {
	java-pkg-simple_src_compile
	find org -type f ! -name "*.java" | xargs jar uvf "${PN}.jar" || die "jar update failed"
}

src_install() {
	java-pkg-simple_src_install
	insinto /usr/share/java-config-2/compiler
	doins "${FILESDIR}/ecj-${SLOT}"
	eprefixify "${D}"/usr/share/java-config-2/compiler/ecj-${SLOT}
}
