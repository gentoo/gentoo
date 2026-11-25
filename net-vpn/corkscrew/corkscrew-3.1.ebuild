# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit python-any-r1

DESCRIPTION="Tool for tunneling SSH through HTTP proxies"
HOMEPAGE="https://github.com/patpadgett/corkscrew/"
SRC_URI="https://github.com/patpadgett/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

DOCS=( CHANGELOG.md NEWS README.md SECURITY.md TODO )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}
