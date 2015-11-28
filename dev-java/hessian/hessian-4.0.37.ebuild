# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Binary web service protocol"
HOMEPAGE="http://hessian.caucho.com/"
SRC_URI="http://hessian.caucho.com/download/${P}-src.jar"

LICENSE="Apache-1.1"
SLOT="4.0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc source"

CDEPEND="java-virtuals/servlet-api:3.0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"

S="${WORKDIR}"

JAVA_SRC_DIR="com"
JAVA_GENTOO_CLASSPATH="servlet-api-3.0"
