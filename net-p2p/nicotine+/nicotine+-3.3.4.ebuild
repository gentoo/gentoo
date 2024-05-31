# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature xdg

DESCRIPTION="Graphical client for the Soulseek peer to peer network written in Python"
HOMEPAGE="https://nicotine-plus.org/"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nicotine-plus-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

# NOTE: good link - https://github.com/nicotine-plus/nicotine-plus/blob/master/doc/DEPENDENCIES.md
BDEPEND="sys-devel/gettext" # TODO(setan): maybe add pycodestyle and pylint here if use test
RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	|| ( >=gui-libs/gtk-4.6.9[introspection] >=x11-libs/gtk+-3.22.20:3[introspection] )
"

distutils_enable_tests pytest

DOCS=( AUTHORS.md NEWS.md README.md TRANSLATORS.md )

pkg_postinst() {
	xdg_pkg_postinst

	elog "Nicotine can work with both gtk3+ and gtk4."
	elog "The newer version is preferred but it has worse screen reader support"
	elog "If you need it you can switch to gtk3+ by running nicotine"
	elog "with an environmental variable like this:"
	elog "   $ NICOTINE_GTK_VERSION=3 nicotine"

	optfeature "Adwaita theme on GNOME (GTK 4)" gui-libs/libadwaita
	optfeature "Chat spellchecking (GTK 3)" app-text/gspell
}
