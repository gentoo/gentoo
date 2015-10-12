# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Binary web service protocol"
HOMEPAGE="http://hessian.caucho.com/"
SRC_URI="http://hessian.caucho.com/download/${P}-src.jar"

LICENSE="Apache-1.1"
SLOT="4.0"
KEYWORDS="amd64 ~ppc x86"

IUSE=""

COMMON_DEP="java-virtuals/servlet-api:2.5"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

EANT_BUILD_TARGET="all"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}

	mkdir -p "${S}/src"
	mkdir -p "${S}/lib"

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml"

	cd "${S}/src"
	mv ../com .

	cd "${S}/lib"
	java-pkg_jarfrom --virtual servlet-api:2.5
}

src_install() {
	java-pkg_dojar "hessian.jar"
	java-pkg_dojar "burlap.jar"
	java-pkg_dojar "services.jar"

	use source && java-pkg_dosrc src
}
