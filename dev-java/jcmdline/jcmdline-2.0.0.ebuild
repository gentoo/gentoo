# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for parsing/handling of command line parameters"
HOMEPAGE="http://jcmdline.sourceforge.net/"
SRC_URI="mirror://sourceforge/jcmdline/${P}.zip"
LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

java_prepare() {
	java-pkg_clean
	rm -rf testsrc || die
}
