# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-any-r1

MY_PV="${PV//./-}"

DESCRIPTION="Open source implementation of the Pragmatic General Multicast specification"
HOMEPAGE="https://github.com/steve-o/openpgm"
SRC_URI="https://github.com/steve-o/${PN}/archive/release-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"
IUSE="static-libs"

DEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${PN}-release-${MY_PV}/${PN}/pgm"

src_install() {
	DOCS=( "${S}"/../doc/. "${S}"/README )

	autotools-utils_src_install
}
