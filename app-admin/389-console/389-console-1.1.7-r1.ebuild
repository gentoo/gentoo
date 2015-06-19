# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/389-console/389-console-1.1.7-r1.ebuild,v 1.1 2014/08/18 19:47:08 creffett Exp $

EAPI=5

JAVA_PKG_IUSE=""

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="A Java based console for remote management 389 server"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2
	http://dev.gentoo.org/~lxnay/${PN}/fedora.png"

LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP="dev-java/jss:3.4
	dev-java/ldapsdk:4.1
	>=dev-java/idm-console-framework-1.1"

RDEPEND="|| ( >=virtual/jre-1.6 >=virtual/jdk-1.6 )
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

src_prepare() {
	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
	java-pkg_jar-from jss-3.4 xpclass.jar jss4.jar
	java-pkg_jar-from idm-console-framework-1.1
}

src_compile() {
	eant -Dbuilt.dir="${S}"/build \
		-Dldapjdk.local.location="${S}" \
		-Djss.local.location="${S}" \
		-Dconsole.local.location="${S}" ${antflags} \
		|| die "eant failed"
}

src_install() {
	java-pkg_newjar "${S}"/build/389-console-${PV}_en.jar 389-console_en.jar
	java-pkg_dolauncher ${PN} --main com.netscape.management.client.console.Console \
		--pwd "/usr/share/dirsrv/html/java/" \
		--pkg_args "-Djava.util.prefs.systemRoot=\"\$HOME/.${PN}\" -Djava.util.prefs.userRoot=\"\$HOME/.${PN}\"" \
		|| die

	doicon "${DISTDIR}"/fedora.png || die "doicon failed"
	make_desktop_entry ${PN} "Port389 Management Console" fedora System
}
