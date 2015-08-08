# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A framework to assist in controlling the run-time ClassLoader"
HOMEPAGE="http://forehead.werken.com"
SRC_URI="mirror://gentoo/forehead-${PV}.tbz2"

LICENSE="Werken-1.1.1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.3"
RDEPEND=">=virtual/jre-1.3"

S="${WORKDIR}/${PN}"
JAVA_SRC_DIR="src"
