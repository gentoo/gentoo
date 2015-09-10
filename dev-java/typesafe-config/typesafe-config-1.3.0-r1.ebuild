# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

JAVA_PKG_IUSE="doc source"

DESCRIPTION="a library of arguably useful Java utilities"
HOMEPAGE="https://github.com/typesafehub/config"
SRC_URI="https://github.com/typesafehub/config/archive/v${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc source"

CDEPEND=""

RDEPEND=">=virtual/jre-1.8
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.8
	app-arch/zip
	${CDEPEND}"
