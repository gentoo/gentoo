# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java based Database Explorer"
HOMEPAGE="http://jxtray.sourceforge.net"
SRC_URI="mirror://sourceforge/jxtray/${PN}-src-${PV}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc firebird mssql mysql postgres"

COMMON_DEP="
	dev-java/jdom:0
	>=dev-java/kunststoff-2.0.2:2.0
	dev-java/poi:0
	dev-java/sax:0
	>=dev-java/xerces-2.7:2
	dev-java/xml-commons:0
	firebird? ( dev-java/jdbc-jaybird:0 )
	mssql? ( >=dev-java/jtds-1.2:1.2 )
	mysql? ( dev-java/jdbc-mysql:0 )
	postgres? ( dev-java/jdbc-postgresql:0 )
	!firebird? ( !mssql? ( !postgres? ( dev-java/jdbc-mysql:0 ) ) )"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-src-${PV}"

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}"/build.xml "${FILESDIR}"/default.properties "${S}"
	local cp=""

	cd "${S}"/lib
	rm *.jar
	cp="${cp}:$(java-pkg_getjars jdom)"
	cp="${cp}:$(java-pkg_getjars xerces-2)"
	cp="${cp}:$(java-pkg_getjars xml-commons)"
	cp="${cp}:$(java-pkg_getjars sax)"
	cp="${cp}:$(java-pkg_getjars poi)"

	cd "${S}"/lib/lookandfeel
	rm *.jar
	cp="${cp}:$(java-pkg_getjars kunststoff-2.0)"

	cd "${S}"/lib/drivers
	rm *.jar
	use firebird && cp="${cp}:$(java-pkg_getjars jdbc-jaybird)"
	use mssql && cp="${cp}:$(java-pkg_getjars jtds-1.2)"
	use mysql && cp="${cp}:$(java-pkg_getjars jdbc-mysql)"
	use postgres && cp="${cp}:$(java-pkg_getjars jdbc-postgresql)"

	echo "classpath=${cp}" > "${S}"/build.properties
}

src_compile() {
	eant jar $(use_doc javadoc)
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar

	java-pkg_dolauncher jxtray --main jxtray.Jxtray

	dodoc CHANGELOG.txt README.txt
	use doc && java-pkg_dojavadoc javadoc
}
