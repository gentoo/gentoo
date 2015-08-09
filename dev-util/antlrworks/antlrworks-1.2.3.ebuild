# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit java-pkg-2

DESCRIPTION="A novel grammar development environment for ANTLR v3 grammars"
HOMEPAGE="http://www.antlr.org/works/index.html"
SRC_URI="http://www.antlr.org/download/${P}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

IUSE=""

COMMON_DEP="
	dev-java/stringtemplate:0
	dev-java/antlr:0
	>=dev-java/antlr-3.1.3:3
	dev-java/jgoodies-forms:0
"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}"

java_prepare() {
	epatch "${FILESDIR}/antlr-3.1.3.patch"
	rm -vr src/aw/org/antlr/xjlib/appkit/app/MacOS/ || die
	rm -v lib/*.jar || die
	mkdir build
}

src_compile() {
	find src/aw -name "*.java" > "${T}/source.list"
	ejavac -d build -classpath \
		$(java-pkg_getjars antlr,antlr-3,jgoodies-forms,stringtemplate) \
		"@${T}/source.list"

	local dest="${S}/${PN}.jar"

	cd src/aw || die
	jar cf "${dest}" $(find -type f -and -not -name "*.java" ) || die

	cd "${S}/build" || die
	jar uf "${dest}" org || die
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	java-pkg_dolauncher ${PN} --main "org.antlr.works.IDE"
}
