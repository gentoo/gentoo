# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_4,3_5,3_6} )
PYTHON_REQ_USE="sqlite(+)"

inherit python-single-r1

DESCRIPTION="Completion input method for IBus"
HOMEPAGE="https://mike-fabian.github.io/ibus-typing-booster"
SRC_URI="https://github.com/mike-fabian/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="${PYTHON_DEPS}
	app-i18n/ibus[python(+),${PYTHON_USEDEP}]
	dev-libs/m17n-lib
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	>=dev-db/m17n-db-1.7"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"
