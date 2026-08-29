# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="source"

inherit java-pkg-2

DESCRIPTION="POP/IMAP/SMTP/Caldav/Carddav/LDAP Exchange and Office 365 Gateway"
HOMEPAGE="https://davmail.sourceforge.net"
SRC_URI="https://github.com/mguessan/davmail/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/log4j-12-api:0
	dev-java/javax-mail:0
	dev-java/httpcore:0
	dev-java/httpcomponents-client:4
	dev-java/jackrabbit-webdav:2.20
	dev-java/jettison:0
	dev-java/commons-codec:0
	dev-java/swt:0
	dev-java/jcifs:1.1
	dev-java/stax2-api:0
	dev-java/htmlcleaner:0
	dev-java/jakarta-activation-api:1
"
DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"
RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

RESTRICT="test"
PATCHES=( "${FILESDIR}/davmail-6.5.0-source-target.patch"
		  "${FILESDIR}/davmail-6.4.0-remove-windows-service.patch" )

src_prepare() {
	java-pkg_clean
	default
	java-pkg-2_src_prepare

	java-pkg_jar-from --into lib/ log4j-12-api
	java-pkg_jar-from --into lib/ javax-mail
	java-pkg_jar-from --into lib/ httpcore
	java-pkg_jar-from --into lib/ httpcomponents-client-4
	java-pkg_jar-from --into lib/ jackrabbit-webdav-2.20
	java-pkg_jar-from --into lib/ jettison
	java-pkg_jar-from --into lib/ commons-codec
	java-pkg_jar-from --into lib/ swt
	java-pkg_jar-from --into lib/ jcifs-1.1
	java-pkg_jar-from --into lib/ stax2-api
	java-pkg_jar-from --into lib/ htmlcleaner
	java-pkg_jar-from --into lib/ jakarta-activation-api-1
}

src_compile() {
	eant jar \
		-Dant.build.javac.source="$(java-pkg_get-source)" \
		-Dant.build.javac.target="$(java-pkg_get-target)"
}

src_install() {
	java-pkg_newjar "dist/davmail.jar"

	java-pkg_dolauncher "${PN}" \
			--main davmail.DavGateway

	einstalldocs
	use source && java-pkg_dosrc src/java/davmail
}
