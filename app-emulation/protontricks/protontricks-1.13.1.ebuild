# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} pypy3 pypy3_11 )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi xdg-utils

DESCRIPTION="app-emulation/winetricks wrapper for Proton (Steam Play) games"
HOMEPAGE="https://github.com/Matoking/protontricks"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="+gui"

RDEPEND="
	app-emulation/winetricks[gui?]
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP}]
		>=dev-python/vdf-3.4_p20240630[${PYTHON_USEDEP}]
	')
	gui? ( gnome-extra/zenity )"
BDEPEND="$(python_gen_cond_dep '
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
')"

DOCS=( CHANGELOG.md README.md )

distutils_enable_tests pytest

src_prepare() {
	default
	sed -i "/^from /s/\._vdf/vdf/g" src/protontricks/steam.py || die
	rm -r src/protontricks/_vdf || die
}

pkg_postinst() {
	xdg_desktop_database_update

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

pkg_postrm() {
	xdg_desktop_database_update
}
