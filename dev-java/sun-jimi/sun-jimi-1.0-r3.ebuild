# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc"

inherit java-pkg-2

DESCRIPTION="Jimi is a class library for managing images"
HOMEPAGE="http://www.oracle.com/technetwork/java/index.html"
SRC_URI="jimi1_0.zip"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.3"
DEPEND=">=virtual/jdk-1.3
	app-arch/unzip"

RESTRICT="bindist fetch"

S=${WORKDIR}/Jimi

pkg_nofetch() {
	local download_url="http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-java-client-419417.html#7259-jimi_sdk-1.0-oth-JPR"
	einfo "Please download ${A} from the following url and place it into your"
	einfo "DISTDIR directory:"
	einfo "${download_url} "
}

java_prepare() {
	rm -r src/classes/* || die
}

src_compile() {
	cd "${S}/src"
	ejavac -classpath . -d classes $(cat main_classes.txt) || die "failes to	compile"
	jar -cf ${PN}.jar -C classes . || die "failed to create jar"
}

src_install() {
	java-pkg_dojar src/${PN}.jar

	dodoc Readme
	use doc && java-pkg_dohtml -r docs/*
}
