# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library for treemapping data"
HOMEPAGE="http://jtreemap.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${PN}-site-${PV}/JTreeMap"

JAVA_SRC_DIR="src/main"

JAVA_ENCODING="ISO-8859-1"

java_prepare() {
	pushd .. > /dev/null || die
	java-pkg_clean
	popd > /dev/null || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN}-demo --main net.sf.jtreemap.swing.example.JTreeMapExample
}
