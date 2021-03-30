# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="frr-${PV}"
PYTHON_COMPAT=( python3_{7..9} )
inherit autotools python-single-r1

DESCRIPTION="Standalone clippy tool built from FRR sources"
HOMEPAGE="https://frrouting.org/"
SRC_URI="https://github.com/FRRouting/frr/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/flex"

S="${WORKDIR}/frr-${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-clippy-only
}

src_install() {
	dobin lib/clippy
}
