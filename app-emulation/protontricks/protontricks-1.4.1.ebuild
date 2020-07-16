# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="app-emulation/winetricks wrapper for Proton (Steam Play) games"
HOMEPAGE="https://github.com/Matoking/protontricks"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="+gui"

BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools_scm[${PYTHON_USEDEP}]
	')"
RDEPEND="${PYTHON_DEPS}
	app-emulation/winetricks
	$(python_gen_cond_dep '
		dev-python/vdf[${PYTHON_MULTI_USEDEP}]
	')
	gui? ( gnome-extra/zenity
		|| (
			app-emulation/winetricks[gtk]
			app-emulation/winetricks[kde]
		)
	)"

# Tarballs from PyPI do not contain tests, and we cannot use GitHub releases
# any more because they are incompatible with setuptools_scm.
RESTRICT="test"

DOCS=(CHANGELOG.md README.md)

pkg_postinst() {
	elog

	if ! use gui; then
		ewarn "Please note that disabling USE=gui does *not* presently remove the --gui command-line option,"
		ewarn "it just means using this option will fail unless gnome-extra/zenity happens to be installed."
		ewarn
	fi

	elog "Protontricks can only find games for which a Proton prefix already exists."
	elog "Make sure to run a Proton game at least once before trying to use protontricks on it."
	elog
}
