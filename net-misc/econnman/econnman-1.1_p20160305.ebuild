# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit autotools python-single-r1

DESCRIPTION="ConnMan User Interface written with EFL & python"
HOMEPAGE="https://phab.enlightenment.org/w/projects/econnman/ https://www.enlightenment.org/"
SRC_URI="https://dev.gentoo.org/~juippis/distfiles/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-libs/efl[X,connman]
	$(python_gen_cond_dep '
		dev-python/python-efl[${PYTHON_USEDEP}]
	')"

src_prepare() {
	default
	python_fix_shebang econnman-bin.in
	eautoreconf
}

src_install() {
	default
	rm -r "${ED}"/var/ || die
}
