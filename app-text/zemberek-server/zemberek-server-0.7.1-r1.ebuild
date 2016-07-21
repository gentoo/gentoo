# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Turkish spell checker server based on Zemberek NLP library"
HOMEPAGE="https://github.com/ahmetaa/zemberek-nlp"
SRC_URI="https://zemberek.googlecode.com/files/${PN}-nolibs-${PV}.tar.gz"

LICENSE="MPL-1.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
S="${WORKDIR}"
IUSE=""

CDEPEND="dev-java/zemberek[l10n_tr]
	 dev-java/dbus-java
	 dev-java/mina-core"

RDEPEND="${CDEPEND}
	dev-java/slf4j-nop
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6"

EANT_BUILD_TARGET="dist"

src_unpack() {
	unpack ${A}
	mkdir lib || die
	cd lib || die
	java-pkg_jarfrom zemberek zemberek2-cekirdek.jar
	java-pkg_jarfrom zemberek zemberek2-tr.jar
	java-pkg_jarfrom dbus-java dbus.jar
	java-pkg_jarfrom mina-core
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_dolauncher zemberek-server \
		--java_args \
		"-Xverify:none -Xms12m -Xmx14m -DConfigFile=/etc/zemberek-server.ini" \
		--pre "${FILESDIR}"/pre \
		--main net.zemberekserver.server.ZemberekServer
	java-pkg_register-dependency slf4j-nop

	doinitd "${FILESDIR}"/zemberek-server
	insinto /etc/dbus-1/system.d
	doins dist/config/zemberek-server.conf
	insinto /etc
	newins config/conf.ini zemberek-server.ini
}
