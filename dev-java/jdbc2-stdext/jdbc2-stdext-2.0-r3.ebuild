# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

stdext_src="jdbc2_0-stdext-src.zip"
stdext_jar="jdbc2-stdext.jar"

DESCRIPTION="A standard set of libs for Server-Side JDBC support"
HOMEPAGE="http://www.oracle.com/technetwork/java/index.html"
SRC_URI="${stdext_src}"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="bindist fetch"

RDEPEND="
	>=virtual/jre-1.4"

DEPEND="
	>=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}"

pkg_nofetch() {
	local download_url="http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-database-419422.html#7099-jdbc-2.0-src-oth-JPR"

	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${download_url}"
	einfo " 2. Select 'JDBC Standard Extension Source 2.0'"
	einfo " 3. Download ${stdext_src}"
	einfo " 4. Move to your DISTDIR directory"
	einfo
	einfo " Run emerge on this package again to complete"
	einfo
}

src_unpack() {
	mkdir src || die
	cd src || die
	unpack ${A}
}

src_compile() {
	mkdir classes || die
	ejavac -d classes src/javax/sql/*.java
	jar cf "${stdext_jar}" -C classes/ . || die "jar failed"

	if use doc; then
		javadoc -d api -source $(java-pkg_get-source) -sourcepath src/ \
			javax.sql || die "javadoc failed"
	fi
}

src_install() {
	java-pkg_dojar "${stdext_jar}"

	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc src/*
}
