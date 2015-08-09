# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2 java-ant-2

MY_PV=${PV/_/}

DESCRIPTION="Open source implementation of Service Provisioning Markup Language (SPML)"
HOMEPAGE="http://www.openspml.org/"
SRC_URI="http://www.openspml.org/Files/${PN}_v${PV}.zip"

LICENSE="openspml"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.4"

S="${WORKDIR}/${PN}"

src_unpack() {

	unpack "${A}"

	# Argh...
	cd "${S}"
	find . -type f -exec chmod 644 {} \;
	find . -type d -exec chmod 755 {} \;

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml"

}

src_compile() {

	cd "${S}/lib"

	cd "${S}"
	eant jar

}

src_install() {

	java-pkg_dojar "${S}/lib/openspml.jar"

	use source && java-pkg_dosrc "${S}/src/*"
	dodoc README history.txt
	use doc && java-pkg_dojavadoc doc

}
