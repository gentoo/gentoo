# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PV=${PV/_alpha/.a}
MY_PV=${MY_PV/_rc/.rc}

DESCRIPTION="389 Server Management Console (jar and help files)"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="dev-java/jss:3.4
	dev-java/ldapsdk:4.1
	>=dev-java/idm-console-framework-1.1.7"
RDEPEND="|| ( >=virtual/jre-1.5 >=virtual/jdk-1.5 )
	${COMMON_DEP}"
DEPEND="sys-apps/sed
	>=virtual/jdk-1.5
	${COMMON_DEP}"
PDEPEND="net-nds/389-admin"

src_prepare() {
	# Gentoo java rules say no jars with version number
	# so sed away the version indicator '-'
	sed -e "s!-\*!\*!g" -i build.xml

	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
	java-pkg_jar-from jss-3.4 xpclass.jar jss4.jar
	java-pkg_jar-from idm-console-framework-1.1
}

src_compile() {
	eant -Dbuilt.dir="${S}"/build \
	     -Dldapjdk.location="${S}" \
	     -Djss.location="${S}" \
	     -Dconsole.location="${S}" ${antflags}
	use doc && eant -Dbuilt.dir="${S}"/build \
	     -Dldapjdk.location="${S}" \
	     -Djss.location="${S}" \
	     -Dconsole.location="${S}" ${antflags} javadoc
}

src_install() {
	java-pkg_jarinto /usr/share/dirsrv/html/java
	# have to install versioned jars, otherwise 389-console will crash
	java-pkg_newjar "${S}"/build/package/389-admin-${MY_PV}.jar 389-admin-${MY_PV}.jar
	java-pkg_newjar "${S}"/build/package/389-admin-${MY_PV}_en.jar 389-admin-${MY_PV}_en.jar

	dosym 389-admin-${MY_PV}.jar /usr/share/dirsrv/html/java/389-admin.jar
	dosym 389-admin-${MY_PV}.jar /usr/share/dirsrv/html/java/389-admin-${SLOT}.jar
	dosym 389-admin-${MY_PV}_en.jar /usr/share/dirsrv/html/java/389-admin_en.jar
	dosym 389-admin-${MY_PV}_en.jar /usr/share/dirsrv/html/java/389-admin-${SLOT}_en.jar

	insinto /usr/share/dirsrv/manual/en/admin
	doins "${S}"/help/en/*.html
	doins "${S}"/help/en/tokens.map

	insinto /usr/share/dirsrv/manual/en/admin/help
	doins "${S}"/help/en/help/*.html

	use doc && java-pkg_dojavadoc build/doc
	use source && java-pkg_dosrc src/com
}
