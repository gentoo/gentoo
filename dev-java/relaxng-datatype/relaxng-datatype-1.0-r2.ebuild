# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6

JAVA_PKG_IUSE="doc source"

MY_PN="relaxngDatatype"
MY_P="${MY_PN}-${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Interface between RELAX NG validators and datatype libraries"
HOMEPAGE="http://relaxng.org/"
SRC_URI="mirror://sourceforge/relaxng/${MY_P}.zip -> ${P}.zip"

KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
LICENSE="BSD"
SLOT="0"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

DOCS=( README.txt )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs
}
