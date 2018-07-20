# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Java based console for remote management 389 server"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2
	https://dev.gentoo.org/~lxnay/${PN}/fedora.png"

LICENSE="LGPL-2.1"
SLOT="1.1"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-java/jss:3.4
	dev-java/ldapsdk:4.1
	>=dev-java/idm-console-framework-1.1"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

src_prepare() {
	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
	java-pkg_jar-from jss-3.4 xpclass.jar jss4.jar
	java-pkg_jar-from idm-console-framework-1.1
}

src_compile() {
	eant -Dbuilt.dir="${S}"/build \
		-Dldapjdk.local.location="${S}" \
		-Djss.local.location="${S}" \
		-Dconsole.local.location="${S}" ${antflags}
}

src_install() {
	java-pkg_newjar "${S}"/build/389-console-${PV}_en.jar 389-console_en.jar
	java-pkg_dolauncher ${PN} \
		--main com.netscape.management.client.console.Console \
		--pwd "/usr/share/dirsrv/html/java/" \
		--pkg_args "-Djava.util.prefs.systemRoot=\"\$HOME/.${PN}\" -Djava.util.prefs.userRoot=\"\$HOME/.${PN}\""

	doicon "${DISTDIR}"/fedora.png
	make_desktop_entry ${PN} "Port389 Management Console" fedora System
}
