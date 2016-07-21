# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High-performance JSON processor"
HOMEPAGE="http://jackson.codehaus.org"
SRC_URI="http://repo1.maven.org/maven2/org/codehaus/${PN}/${PN}-core-lgpl/${PV}/${PN}-core-lgpl-${PV}-sources.jar"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"
