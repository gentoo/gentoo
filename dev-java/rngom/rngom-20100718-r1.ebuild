# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="RNGOM is an open-source Java library for parsing RELAX NG grammars"
HOMEPAGE="https://rngom.dev.java.net/"
SRC_URI="https://repo1.maven.org/maven2/org/kohsuke/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

CDEPEND="
	dev-java/xsdlib:0
	dev-java/relaxng-datatype:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	xsdlib
	relaxng-datatype
"

JAVA_RM_FILES=(
	Token.java
	TokenMgrError.java
	ParseException.java
	UCode_UCodeESC_CharStream.java
	org/kohsuke/rngom/parse/compact/CompactSyntax.java
	org/kohsuke/rngom/parse/compact/EOFException.java
	org/kohsuke/rngom/parse/compact/JavaCharStream.java
	org/kohsuke/rngom/parse/compact/CompactParseable.java
	org/kohsuke/rngom/parse/compact/EscapeSyntaxException.java
	org/kohsuke/rngom/parse/compact/CompactSyntaxConstants.java
	org/kohsuke/rngom/parse/compact/CompactSyntaxTokenManager.java
)

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" . -name "*.properties"
}
