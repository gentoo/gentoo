# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_USE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jetty's Utils"

MY_PN="jetty"
MY_PV="${PV/2015/v2015}"
MY_P="${MY_PN}-${MY_PV}"

SLOT="$(get_version_component_range 1-2)"
SRC_URI="https://github.com/eclipse/${MY_PN}.project/archive/${MY_P}.zip"
HOMEPAGE="http://www.eclipse.org/${MY_PN}/"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
IUSE=""

CDEPEND="dev-java/slf4j-api:0
	java-virtuals/servlet-api:3.1"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8"

S="${WORKDIR}/${MY_PN}.project-${MY_P}/${PN}/"

JAVA_GENTOO_CLASSPATH="servlet-api-3.1,slf4j-api"
JAVA_SRC_DIR="src/main/java"

java_prepare() {
	java-pkg_clean
}
