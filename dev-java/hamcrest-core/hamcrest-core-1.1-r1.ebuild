# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Library of matchers for building test expressions"
HOMEPAGE="https://github.com/hamcrest"
SRC_URI="https://github.com/${MY_PN}/JavaHamcrest/archive/${MY_PN}-java-${PV}.zip -> ${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-macos ~x64-solaris"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/JavaHamcrest-${MY_PN}-java-${PV}"

JAVA_SRC_DIR="${PN}/src"

java_prepare() {
	java-pkg_clean
}
