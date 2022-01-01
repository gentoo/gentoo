# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2

DESCRIPTION="Oracle SQL Developer is a graphical tool for database development"
HOMEPAGE="https://www.oracle.com/technetwork/developer-tools/sql-developer/overview/index.html"
SRC_URI="${P}-no-jre.zip"

RESTRICT="fetch"

LICENSE="OTN"
SLOT="0"
KEYWORDS="-* ~amd64"

IUSE="mssql mysql postgres sybase"

RDEPEND="mssql? ( dev-java/jtds:1.3 )
	mysql? ( dev-java/jdbc-mysql:0 )
	postgres? ( dev-java/jdbc-postgresql:0 )
	sybase? ( dev-java/jtds:1.3 )
	>=dev-java/openjdk-8:*[javafx]
	>=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

QA_PREBUILT="
	opt/${PN}/netbeans/platform/modules/lib/amd64/linux/libjnidispatch-422.so
"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Oracle SQL Developer for other platforms"
	eerror "		${SRC_URI}"
	eerror "and move it to /var/cache/distfiles"
}

src_prepare() {
	default
	find ./ \( -iname "*.exe" -or -iname "*.dll" -or -iname "*.bat" \) -exec rm {} + || die
	sed -i 's|"`dirname $0`"|/opt/sqldeveloper|' sqldeveloper.sh || die

	rm -r netbeans/platform/modules/lib/i386 || die

	# they both use jtds, enabling one of them also enables the other one
	if use mssql && ! use sybase; then
		einfo "You requested MSSQL support, this also enables Sybase support."
	fi
	if use sybase && ! use mssql; then
		einfo "You requested Sybase support, this also enables MSSQL support."
	fi

	if use mssql || use sybase; then
		echo "AddJavaLibFile $(java-pkg_getjars jtds-1.3)" >> sqldeveloper/bin/sqldeveloper.conf || die
	fi

	if use mysql; then
		echo "AddJavaLibFile $(java-pkg_getjars jdbc-mysql)" >> sqldeveloper/bin/sqldeveloper.conf || die
	fi

	if use postgres; then
		echo "AddJavaLibFile $(java-pkg_getjars jdbc-postgresql)" >> sqldeveloper/bin/sqldeveloper.conf || die
	fi
}

src_install() {
	insinto /opt/${PN}
	doins -r {configuration,d{ataminer,ropins},e{quinox,xternal},ide,j{avavm,d{bc,ev},lib,views},module{,s},netbeans,orakafka,rdbms,s{leepycat,ql{developer,j},vnkit}}

	newbin "${FILESDIR}"/${PN}-r1 ${PN}

	newicon icon.png ${PN}-32x32.png
	make_desktop_entry ${PN} "Oracle SQL Developer" ${PN}-32x32

	# This is normally called automatically by java-pkg_dojar, which
	# hasn't been used above. We need to create package.env to help the
	# launcher select the correct VM.
	java-pkg_do_write_
}

pkg_postinst() {
	echo
	einfo "If you want to use the TNS connection type you need to set up the"
	einfo "TNS_ADMIN environment variable to point to the directory your"
	einfo "tnsnames.ora resides in."
	echo
}
