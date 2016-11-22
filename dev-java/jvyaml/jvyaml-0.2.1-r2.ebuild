# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java YAML parser and emitter"
HOMEPAGE="https://jvyaml.dev.java.net/"
SRC_URI="mirror://gentoo/${PN}-src-${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
	rm -rv src/test || die
}
