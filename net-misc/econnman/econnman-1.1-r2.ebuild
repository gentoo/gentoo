# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit python-single-r1

DESCRIPTION="ConnMan User Interface written with EFL & python"
HOMEPAGE="https://phab.enlightenment.org/w/projects/econnman/ https://www.enlightenment.org/"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

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
	sed -e \
		's/Categories=Network;Settings;Enlightenment;/Categories=Network;Settings;Dialup;Monitor;/g' \
		-i data/desktop/econnman{.desktop,-agent.desktop} || die
}
