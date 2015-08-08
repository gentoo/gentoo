# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2 java-ant-2

MY_PV=${PV/_/}

DESCRIPTION="Open source implementation of Service Provisioning Markup Language (SPML)"
HOMEPAGE="http://www.openspml.org/"
SRC_URI="http://www.openspml.org/Files/openspml_v2-${MY_PV}.tgz"

LICENSE="CDDL-Schily"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc source"

COMMON_DEP="
	=dev-java/servletapi-2.4*
	dev-java/openspml"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4"

S="${WORKDIR}"

src_unpack() {

	unpack "${A}"
	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die "cp failed"

	rm -f "${S}/lib/*"

}

src_compile() {

	cd "${S}/lib"
	rm -f *.jar
	java-pkg_jar-from servletapi-2.4
	java-pkg_jar-from openspml

	cd "${S}"
	eant jar

}

src_install() {

	java-pkg_dojar "${S}/openspml2.jar"

	use source && java-pkg_dosrc "${S}/src/java/*"
	use doc && {
		java-pkg_dohtml -r docs/api
		dodoc docs/ToolkitOverview.html
		dodoc docs/DSML_2.0_Profile_Overview.txt
	}

}
