# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit go-module python-any-r1

DESCRIPTION="Converts images from GIF format to PNG format"
HOMEPAGE="http://catb.org/~esr/gif2png/"
SRC_URI="http://catb.org/~esr/${PN}/${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/gif2png/releases/download/${PV}/${P}-deps.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		install
}
