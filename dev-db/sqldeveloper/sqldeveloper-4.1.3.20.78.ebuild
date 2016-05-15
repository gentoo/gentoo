# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils java-pkg-2

DESCRIPTION="Oracle SQL Developer is a graphical tool for database development"
HOMEPAGE="http://www.oracle.com/technetwork/developer-tools/sql-developer/overview/index.html"
SRC_URI="${P}-no-jre.zip"

RESTRICT="fetch"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="mssql mysql sybase"

DEPEND="mssql? ( dev-java/jtds:1.2 )
	mysql? ( dev-java/jdbc-mysql:0 )
	sybase? ( dev-java/jtds:1.2 )"
RDEPEND=">=virtual/jdk-1.8.0
	dev-java/java-config:2
	${DEPEND}"

S="${WORKDIR}/${PN}"

QA_PREBUILT="
opt/${PN}/netbeans/platform/modules/lib/amd64/linux/*.so
opt/${PN}/netbeans/platform/modules/lib/i386/linux/*.so
"

pkg_nofetch() {
	eerror "Please go to"
	eerror "	${HOMEPAGE}"
	eerror "and download"
	eerror "	Oracle SQL Developer for other platforms"
	eerror "		${SRC_URI}"
	eerror "and move it to ${DISTDIR}"
}

src_prepare() {
	# we don't need these, do we?
	find ./ \( -iname "*.exe" -or -iname "*.dll" -or -iname "*.bat" \) -exec rm {} +

	# they both use jtds, enabling one of them also enables the other one
	if use mssql && ! use sybase; then
		einfo "You requested MSSQL support, this also enables Sybase support."
	fi
	if use sybase && ! use mssql; then
		einfo "You requested Sybase support, this also enables MSSQL support."
	fi

	if use mssql || use sybase; then
		echo "AddJavaLibFile $(java-pkg_getjars jtds-1.2)" >> sqldeveloper/bin/sqldeveloper.conf
	fi

	if use mysql; then
		echo "AddJavaLibFile $(java-pkg_getjars jdbc-mysql)" >> sqldeveloper/bin/sqldeveloper.conf
	fi
}

src_install() {
	dodir /opt/${PN}
	# NOTE For future version to get that line (what to copy) go to the unpacked sources dir
	# using `bash` and press Meta+_ (i.e. Meta+Shift+-) -- that is a builtin bash feature ;-)
	cp -r {configuration,d{ataminer,ropins,vt},e{quinox,xternal},ide,j{avavm,d{bc,ev},lib,views},modules,netbeans,ords,rdbms,s{leepycat,ql{developer,j},vnkit}} \
		"${D}"/opt/${PN}/ || die "Install failed"

	dobin "${FILESDIR}"/${PN} || die "Install failed"

	mv icon.png ${PN}-32x32.png || die
	doicon ${PN}-32x32.png || die
	make_desktop_entry ${PN} "Oracle SQL Developer" ${PN}-32x32 || die
}

pkg_postinst() {
	# this temporary fixes FileNotFoundException with datamodeler
	# this is more like a workaround than permanent fix
	test -d /opt/sqldeveloper/sqldeveloper/extensions/oracle.datamodeler/log \
		|| mkdir /opt/sqldeveloper/sqldeveloper/extensions/oracle.datamodeler/log
	touch /opt/sqldeveloper/sqldeveloper/extensions/oracle.datamodeler/log/datamodeler.log
	chmod -R 1777 /opt/sqldeveloper/sqldeveloper/extensions/oracle.datamodeler/log/datamodeler.log

	# this fixes another datamodeler FileNotFoundException
	# also more like a workaround than permanent fix
	chmod 1777 /opt/sqldeveloper/sqldeveloper/extensions/oracle.datamodeler/types/dr_custom_scripts.xml

	echo
	einfo "If you want to use the TNS connection type you need to set up the"
	einfo "TNS_ADMIN environment variable to point to the directory your"
	einfo "tnsnames.ora resides in."
	echo
	einfo "In order to use SQL Developer you need to enshure you are using proper version Java VM (1.8)"
	einfo "Use eselect java-vm list to get this info,"
	einfo "eselect java-vm set user N to assign user-level value"
	einfo "eselect java-vm set system N as root to set system-wide default"
	echo
}
