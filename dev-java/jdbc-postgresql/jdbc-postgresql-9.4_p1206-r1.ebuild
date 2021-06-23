# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="postgresql-jdbc"
MY_PV="${PV/_p/-}"
MY_P="${MY_PN}-${MY_PV}.src"

DESCRIPTION="JDBC Driver for PostgreSQL"
SRC_URI="https://jdbc.postgresql.org/download/${MY_P}.tar.gz"
HOMEPAGE="https://jdbc.postgresql.org/"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="test"

# it does not compile with jdk 11, newer versions should be fine
# BUILD FAILED
# /var/tmp/portage/dev-java/jdbc-postgresql-9.4_p1206-r1/work/postgresql-jdbc-9.4-1206.src/build.xml:197: Unknown JDK version.
DEPEND="
	virtual/jdk:1.8
	doc? (
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
	)
	test? (
		dev-db/postgresql[server]
		dev-java/ant-junit:0
		dev-java/hamcrest-core:1.3
		dev-java/junit:4
		dev-java/xml-commons-resolver:0
	)"
RDEPEND=">=virtual/jre-1.8:*"

RESTRICT="test" # Requires external postgresql server setup

S="${WORKDIR}/postgresql-jdbc-${MY_PV}.src"

HTML_DOCS=( build/doc/pgjdbc.html )

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_DOC_TARGET="publicapi"

src_prepare() {
	default

	# Strip build.xml of maven deps
	sed -i -e '/<classpath.*dependency\.compile\.classpath/c\' build.xml || die
	sed -i -e '/<classpath.*dependency\.runtime\.classpath/c\' build.xml || die
	sed -i -e '/<classpath.*dependency\.test\.classpath/c\' build.xml || die
	sed -i -e '/<target name="artifact-version"/,/<[/]target>/{s/depends="maven-dependencies"//}' build.xml || die
	sed -i -e '/<target name="compile"/ s/,maven-dependencies//' build.xml || die

	# Remove SSPI, it pulls in Waffle-JNA and is only used on Windows
	sed -i -e '/<include.*sspi/c\' build.xml || die
	rm -vrf org/postgresql/sspi || die "Error removing sspi"
	eapply "${FILESDIR}"/${PN}-9.4_p1204-remove-sspi.patch

	# FIXME @someone who cares: enable through osgi flag?
	sed -i -e '/<include.*osgi/c\' build.xml || die
	sed -i -e '/<test.*osgi/c\' build.xml || die
	rm -vrf org/postgresql/osgi || die "Error removing osgi"
	rm -vrf org/postgresql/test/osgi || die "Error removing osgi tests"
	eapply "${FILESDIR}"/${PN}-9.4_p1201-remove-osgi.patch

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

	ANT_TASKS="ant-junit" eant test -Dgentoo.classpath=$(java-pkg_getjars --build-only "hamcrest-core-1.3,junit-4,xml-commons-resolver")
}

src_install() {
	java-pkg_newjar build/jars/postgresql*.jar jdbc-postgresql.jar

	if use doc ; then
		java-pkg_dojavadoc build/publicapi
		einstalldocs
	fi

	use source && java-pkg_dosrc org
}
