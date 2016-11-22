# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN%-annotations}"
MY_P="${MY_PN}-${PV}"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java annotations for the Error Prone static analysis tool"
HOMEPAGE="http://errorprone.info"
SRC_URI="https://github.com/google/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${MY_P}/annotations"
JAVA_SRC_DIR="src/main/java"
