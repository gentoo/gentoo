# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jcip-annotations/jcip-annotations-1.0.1.ebuild,v 1.3 2015/03/13 10:54:26 chewi Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit versionator java-pkg-2 java-pkg-simple

MY_P="${PN}-$(replace_version_separator $(get_last_version_component_index) -)"

DESCRIPTION="Clean room implementation of the JCIP Annotations"
HOMEPAGE="https://github.com/stephenc/jcip-annotations"
SRC_URI="https://github.com/stephenc/${PN}/archive/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${PN}-${MY_P}/src"
JAVA_SRC_DIR="main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md
}
