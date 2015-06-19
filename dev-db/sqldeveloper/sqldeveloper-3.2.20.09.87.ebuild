# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqldeveloper/sqldeveloper-3.2.20.09.87.ebuild,v 1.4 2013/03/07 18:39:41 ago Exp $

EAPI="2"

inherit eutils java-pkg-2

DESCRIPTION="Oracle SQL Developer is a graphical tool for database development"
HOMEPAGE="http://www.oracle.com/technology/products/database/sql_developer/"
SRC_URI="${P}-no-jre.zip"
RESTRICT="fetch"

LICENSE="OTN"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mssql mysql sybase"

DEPEND="mssql? ( dev-java/jtds:1.2 )
	mysql? ( dev-java/jdbc-mysql:0 )
	sybase? ( dev-java/jtds:1.2 )"
RDEPEND=">=virtual/jdk-1.6.0
	${DEPEND}"

S="${WORKDIR}/${PN}"

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
	find ./ \( -iname "*.exe" -or -iname "*.dll" -or -iname "*.bat" \) -exec rm {} \;

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

	# this fixes internal Classpath warning
	cd "${T}"
	unzip -q "${S}"/jdev/extensions/oracle.jdeveloper.runner.jar META-INF/extension.xml
	sed -i 's@../../../oracle_common/modules/oracle.nlsrtl_11.1.0@../../jlib@' META-INF/extension.xml || die
	zip -rq "${S}"/jdev/extensions/oracle.jdeveloper.runner.jar META-INF/extension.xml
	rm -rf META-INF

	# this fixes another internal Classpath warning
	cd "${T}"
	unzip -q "${S}"/sqldeveloper/extensions/oracle.datamodeler.jar META-INF/extension.xml
	sed -i 's@<classpath>${ide.extension.install.home}/lib/ActiveQueryBuilder.jar</classpath>@<classpath>${ide.extension.install.home}/../../lib/ActiveQueryBuilder.jar</classpath>@' META-INF/extension.xml || die
	zip -rq "${S}"/sqldeveloper/extensions/oracle.datamodeler.jar META-INF/extension.xml
	rm -rf META-INF
}

src_install() {
	dodir /opt/${PN}
	cp -r {dataminer,ide,javavm,jdbc,jdev,jdev.label,jlib,jviews,modules,rdbms,readme.html,sleepycat,${PN},sqlj,timingframework} \
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
}
