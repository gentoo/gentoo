# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Portable and lightweight generic library for handling UTF-8 strings"
HOMEPAGE="https://sourceforge.net/projects/utfcpp/"
SRC_URI="mirror://sourceforge/utfcpp/utf8_v${PV//./_}.zip"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/source"

src_install() {
	doheader utf8.h
	insinto /usr/include/utf8
	doins utf8/{checked,unchecked,core}.h
}
