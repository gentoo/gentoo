# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop edos2unix java-pkg-2 java-pkg-simple

DESCRIPTION="Unofficial online version of the Classic BattleTech board game"
HOMEPAGE="https://megamek.org/"
XSTR="1.4.20"	# treecleaned
FMV="2.3.32"	# presently not packaged
NSV="0.4"		# presently not packaged
CCV="1.10"	# presently not packaged
SRC_URI="https://github.com/MegaMek/megamek/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://repo1.maven.org/maven2/com/thoughtworks/xstream/xstream/${XSTR}/xstream-${XSTR}.jar
	https://repo1.maven.org/maven2/org/freemarker/freemarker/${FMV}/freemarker-${FMV}.jar
	https://repo1.maven.org/maven2/org/nibblesec/serialkiller/${NSV}/serialkiller-${NSV}.jar
	https://repo1.maven.org/maven2/commons-configuration/commons-configuration/${CCV}/commons-configuration-${CCV}.jar
	https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"
S="${WORKDIR}/${P}/megamek"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-java/commons-logging:0[log4j]
	dev-java/commons-text:0
	dev-java/log4j-12-api:2
	dev-java/jackson-databind:0
	dev-java/jackson-dataformat-yaml:0
	dev-java/jakarta-mail:0
	dev-java/jaxb-api:4
	>=virtual/jdk-11:*
"
RDEPEND=">=virtual/jre-11:*"

JAVA_CLASSPATH_EXTRA="
	commons-logging
	commons-text
	jackson-databind
	jackson-dataformat-yaml
	jakarta-mail
	jaxb-api-4
	log4j-12-api-2
"

DOCS=( HACKING )

JAVA_JAR_FILENAME="MegaMek.jar"
JAVA_MAIN_CLASS="megamek.MegaMek"
JAVA_RESOURCE_DIRS=( i18n resources )
JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/xstream-${XSTR}.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/freemarker-${FMV}.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/serialkiller-${NSV}.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/commons-configuration-${CCV}.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/commons-lang-2.6.jar"

	sed -e "s|XmX|Xmx|" \
		-e "s|/usr/share/java|${EPREFIX}/usr/share/${PN}|" \
		-e "s|/usr/share/MegaMek|${EPREFIX}/usr/share/${PN}|" \
		startup.sh > ${PN} || die
	edos2unix ${PN}
}

src_install() {
	dobin ${PN}

	insinto /usr/share/${PN}
	doins -r MegaMek.jar data docs mmconf

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} MegaMek
}
