# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Kunststoff look'n'feel Java library"
HOMEPAGE="http://www.incors.org/archive"
SRC_URI="http://www.incors.org/archive/${P//./_}.zip"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"
