# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Hyperdex macaroons support library"
HOMEPAGE="http://hyperdex.org"
SRC_URI="http://hyperdex.org/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test +python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ) test? ( python )"

# Tests can't function after 2014-12-31 ...
RESTRICT="test"

RDEPEND="
	dev-libs/libsodium
	dev-libs/json-c
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf $(use_enable python python-bindings)
}

src_test() {
	emake -j1 check || die
}
