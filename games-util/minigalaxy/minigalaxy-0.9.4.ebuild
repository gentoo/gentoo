# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eutils xdg-utils

DESCRIPTION="A simple GOG client for Linux"
HOMEPAGE="https://github.com/sharkwouter/minigalaxy"
SRC_URI="https://github.com/sharkwouter/minigalaxy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=""
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	')
	>=net-libs/webkit-gtk-2.6
	>=x11-libs/gtk+-3"

distutils_enable_tests unittest

python_test() {
	"${EPYTHON}" -m unittest tests/*.py || die "Tests failed under ${EPYTHON}"
}

pkg_postinst() {
	xdg_icon_cache_update

	optfeature "running games with system dosbox" games-emulation/dosbox
	optfeature "running games with system scummvm" games-engines/scummvm
}

pkg_postrm() {
	xdg_icon_cache_update
}
