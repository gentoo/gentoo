# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Implementation of JSR295"
HOMEPAGE="https://java.net/projects/beansbinding/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}-src.zip -> ${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_SRC_DIR="src"
