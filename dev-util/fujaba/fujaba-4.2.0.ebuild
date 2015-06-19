# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fujaba/fujaba-4.2.0.ebuild,v 1.10 2015/01/24 11:30:47 monsieurp Exp $
EAPI="5"

inherit java-pkg-2 java-utils-2

MY_PV="${PV//./_}"
MY_PNB="Fujaba_${PV:0:1}"

DESCRIPTION="The Fujaba Tool Suite provides an easy to extend UML and Java development platform"
HOMEPAGE="http://www.fujaba.de/"
SRC_URI="ftp://ftp.uni-paderborn.de/private/fujaba/${MY_PNB}/FujabaToolSuite_Developer${MY_PV}.jar"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
RDEPEND=">=virtual/jre-1.4
	=dev-java/junit-3.8*
	dev-java/log4j
	~dev-java/jdom-1.0_beta10
	dev-java/xerces:1.3
	dev-java/xml-commons-external:1.4"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S="${WORKDIR}"

src_unpack () {
	jar xf "${DISTDIR}"/${A}

	cd 'C_/Dokumente und Einstellungen/Lothar/Eigene Dateien/Deployment/Fujaba 4.2.0/' || die "failed to cd into package"

	rm -f Deploymentdata/libs/junit.jar
	rm -f Deploymentdata/libs/log4j*.jar
	rm -f Deploymentdata/libs/jdom*.jar
	rm -f Deploymentdata/libs/xerces.jar
}

src_install() {
	dodir /opt/${PN}
	cd 'C_/Dokumente und Einstellungen/Lothar/Eigene Dateien/Deployment/Fujaba 4.2.0/' || die "failed to cd into package"

	cp -pPR . "${D}"/opt/${PN} || die "failed to copy"
	chmod -R 755 "${D}"/opt/${PN}/ || die "failed to chmod"

	# Install bundled jars in /opt/${PN}/lib
	java-pkg_jarinto /opt/${PN}/lib
	dojar_list=$(find . -type f -name \*.jar)
	java-pkg_dojar ${dojar_list} || die "failed to java-pkg_dojar"

	# Register them in package.env
	java-pkg_regjar "${D}"/opt/"${PN}"/lib/*.jar || die "failed to java-pkg_regjar"

	# Add additional jars to CP
	cpjar_list=/usr/share
	cpjar_list="${cpjar_list}/log4j/lib/log4j.jar
	${cpjar_list}/xerces-2/lib/xercesImpl.jar
	${cpjar_list}/xml-commons-external-1.4/lib/xml-apis.jar"

	for _jar in ${cpjar_list}; do
		[[ -f ${_jar} ]] && java-pkg_addcp ${_jar} || \
			die "failed to add ${_jar} to CP"
	done

	# Create launcher
	java-pkg_dolauncher "${PN}" --main de.uni_paderborn.fujaba.app.FujabaApp || \
		die "failed to java-pkg_dolauncher"
}
