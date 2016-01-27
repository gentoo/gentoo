# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2

MY_PN=apache-${PN%%-bin}
MY_PV=${PV/_alpha/-alpha-}
MY_P="${MY_PN}-${MY_PV}"
MY_MV="${PV%%.*}"

DESCRIPTION="Project Management and Comprehension Tool for Java"
SRC_URI="mirror://apache/maven/maven-${MY_MV}/${PV}/binaries/${MY_P}-bin.tar.gz"
HOMEPAGE="http://maven.apache.org/"

LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="~amd64 ~x86"

# TODO: Needs further resolution:
#
# - https://bugs.gentoo.org/show_bug.cgi?id=472850
# - https://bugs.gentoo.org/show_bug.cgi?id=477436
#
DEPEND="app-eselect/eselect-java
|| ( dev-java/commons-logging:0 dev-java/log4j:0 dev-java/avalon-logkit:2.0 )
dev-java/aopalliance:1
dev-java/avalon-framework:4.1
dev-java/commons-cli:1
dev-java/commons-io:1
dev-java/javax-inject:0
dev-java/jsoup:0
dev-java/jsr250:0
dev-java/juel:0
dev-java/osgi-core-api:0
java-virtuals/interceptor-api:0
java-virtuals/servlet-api:2.4"

RDEPEND=">=virtual/jdk-1.6
>=virtual/jre-1.6
${DEPEND}"

S="${WORKDIR}/${MY_P}"

MAVEN=${PN}-${SLOT}
MAVEN_SHARE="/usr/share/${MAVEN}"

java_prepare() {
	rm -v bin/*.bat lib/{aopalliance,commons-cli,javax.inject,jsr250}-*.jar || die

	chmod 644 boot/*.jar lib/*.jar conf/settings.xml || die

	# Symlink jars.
	cd lib || die
	java-pkg_jar-from aopalliance-1,avalon-framework-4.1,commons-cli-1,commons-io-1,interceptor-api,javax-inject,jsoup,jsr250,juel,osgi-core-api,servlet-api-2.4
	has_version dev-java/commons-logging:0 && java-pkg_jar-from commons-logging
	has_version dev-java/avalon-logkit:2.0 && java-pkg_jar-from avalon-logkit-2.0
	has_version dev-java/log4j:0 && java-pkg_jar-from log4j
}

# TODO: We should use jars from packages, instead of what is bundled.
src_install() {
	dodir "${MAVEN_SHARE}"

	cp -Rp bin boot conf lib "${ED}/${MAVEN_SHARE}" || die "failed to copy"

	java-pkg_regjar "${ED}/${MAVEN_SHARE}"/boot/*.jar
	java-pkg_regjar "${ED}/${MAVEN_SHARE}"/lib/*.jar

	dodoc NOTICE README.txt

	dodir /usr/bin
	dosym "${MAVEN_SHARE}/bin/mvn" /usr/bin/mvn-${SLOT}

	# See bug #342901.
	echo "CONFIG_PROTECT=\"${MAVEN_SHARE}/conf\"" > "${T}/25${MAVEN}" || die
	doenvd "${T}/25${MAVEN}"
}

pkg_postinst() {
	eselect maven update mvn-${SLOT}
}

pkg_postrm() {
	eselect maven update
}
