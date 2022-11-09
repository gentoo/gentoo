# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple prefix

DMF="R-${PV}-202111241800"

DESCRIPTION="Ant Compiler Adapter for Eclipse Java Compiler"
HOMEPAGE="https://www.eclipse.org/"
SRC_URI="https://download.eclipse.org/eclipse/downloads/drops4/${DMF}/ecjsrc-${PV}.jar"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="4.22"
IUSE=""

CDEPEND="~dev-java/eclipse-ecj-${PV}:${SLOT}
	dev-java/ant-core:0"
# though technically both could be set to 1.8 and it would
# compile using jdk 11+, it would not compile using jdk 1.8
# because eclipse ecj has min jdk 11
RDEPEND="${CDEPEND}
	>=virtual/jre-11:*"
DEPEND="${CDEPEND}
	>=virtual/jdk-17:*"
BDEPEND="app-arch/unzip"

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
	eprefixify "${ED}"/usr/share/java-config-2/compiler/ecj-${SLOT}
}
