# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-eclipse-ecj/ant-eclipse-ecj-4.4.1.ebuild,v 1.5 2014/11/29 13:35:52 ago Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple prefix

DMF="R-${PV}-201409250400"
S="${WORKDIR}"

DESCRIPTION="Ant Compiler Adapter for Eclipse Java Compiler"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops4/${DMF/.0}/ecjsrc-${PV}.jar"

LICENSE="EPL-1.0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
SLOT="4.4"
IUSE=""

RDEPEND=">=virtual/jre-1.6
	~dev-java/eclipse-ecj-${PV}
	>=dev-java/ant-core-1.7"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

JAVA_PKG_FILTER_COMPILER="jikes"

JAVA_GENTOO_CLASSPATH="ant-core,eclipse-ecj-4.4"

java_prepare() {
	rm build.xml || die
}

src_compile() {
	java-pkg-simple_src_compile
	find -name "*.properties" | xargs jar uvf "${S}/${PN}.jar" || die "jar update failed"
}

src_install() {
	java-pkg-simple_src_install
	insinto /usr/share/java-config-2/compiler
	doins "${FILESDIR}/ecj-${SLOT}"
	eprefixify "${D}"/usr/share/java-config-2/compiler/ecj-${SLOT}
}
