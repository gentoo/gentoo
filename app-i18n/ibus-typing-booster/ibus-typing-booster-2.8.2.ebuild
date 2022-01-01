# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite(+)"

inherit python-single-r1

DESCRIPTION="Completion input method for IBus"
HOMEPAGE="https://mike-fabian.github.io/ibus-typing-booster"
SRC_URI="https://github.com/mike-fabian/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-libs/m17n-lib
	$(python_gen_cond_dep '
		app-i18n/ibus[python(+),${PYTHON_MULTI_USEDEP}]
		dev-python/dbus-python[${PYTHON_MULTI_USEDEP}]
		dev-python/pyenchant[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
	')"
RDEPEND="${DEPEND}
	>=dev-db/m17n-db-1.7"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig"
