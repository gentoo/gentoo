# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PN="postgresql-jdbc"
MY_PV="${PV/_p/-}"
MY_P="${MY_PN}-${MY_PV}.src"

DESCRIPTION="JDBC Driver for PostgreSQL"
SRC_URI="http://jdbc.postgresql.org/download/${MY_P}.tar.gz"
HOMEPAGE="http://jdbc.postgresql.org/"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="test"

DEPEND="
	>=virtual/jdk-1.6
	doc? (
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
	)
	test? (
		>=dev-db/postgresql-9.3[server]
		dev-java/ant-junit
		dev-java/junit:4
		dev-java/xml-commons
	)"
RDEPEND=">=virtual/jre-1.6"

RESTRICT="test" # Requires external postgresql server setup

S="${WORKDIR}/postgresql-jdbc-${MY_PV}.src"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_DOC_TARGET="publicapi"

java_prepare() {
	# Strip build.xml of maven deps
	sed -i -e '/<classpath.*dependency\.compile\.classpath/c\' build.xml || die
	sed -i -e '/<classpath.*dependency\.runtime\.classpath/c\' build.xml || die
	sed -i -e '/<classpath.*dependency\.test\.classpath/c\' build.xml || die
	sed -i -e '/<target name="artifact-version"/,/<[/]target>/{s/depends="maven-dependencies"//}' build.xml || die
	sed -i -e '/<target name="compile"/ s/,maven-dependencies//' build.xml || die

	# Remove SSPI, it pulls in Waffle-JNA and is only used on Windows
	sed -i -e '/<include.*sspi/c\' build.xml || die
	rm -vrf org/postgresql/sspi || die "Error removing sspi"
	epatch "${FILESDIR}"/${PN}-9.4_p1204-remove-sspi.patch

	# FIXME @someone who cares: enable through osgi flag?
	sed -i -e '/<include.*osgi/c\' build.xml || die
	sed -i -e '/<test.*osgi/c\' build.xml || die
	rm -vrf org/postgresql/osgi || die "Error removing osgi"
	rm -vrf org/postgresql/test/osgi || die "Error removing osgi tests"
	epatch "${FILESDIR}"/${PN}-9.4_p1201-remove-osgi.patch

	java-pkg_clean
}

src_compile() {
	EANT_BUILD_TARGET="release-version jar"
	java-pkg-2_src_compile

	# There is a task that creates this doc but I didn't find a way how to use system catalog
	# to lookup the stylesheet so the 'doc' target is rewritten here to use system call instead.
	if use doc; then
		mkdir -p "${S}/build/doc" || die
		xsltproc -o "${S}/build/doc/pgjdbc.html" http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook.xsl \
			"${S}/doc/pgjdbc.xml" || die
	fi
}

src_test() {
	einfo "In order to run the tests successfully, you have to have:"
	einfo "1) PostgreSQL server running"
	einfo "2) database 'test' defined with user 'test' with password 'test'"
	einfo "   as owner of the database"
	einfo "3) plpgsql support in the 'test' database"
	einfo
	einfo "You can find a general info on how to perform these steps at"
	einfo "https://wiki.gentoo.org/wiki/PostgreSQL"

	ANT_TASKS="ant-junit" eant test -Dgentoo.classpath=$(java-pkg_getjars --build-only "junit-4,xml-commons")
}

src_install() {
	java-pkg_newjar build/jars/postgresql*.jar jdbc-postgresql.jar

	if use doc ; then
		java-pkg_dojavadoc build/publicapi
		dohtml build/doc/pgjdbc.html
	fi

	use source && java-pkg_dosrc org
}
