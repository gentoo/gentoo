# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} pypy3 )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 xdg-utils

COMMIT="f7b1fa33b0438dbd72f7222703f8442e40edc510"
export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_p*}"

DESCRIPTION="app-emulation/winetricks wrapper for Proton (Steam Play) games"
HOMEPAGE="https://github.com/Matoking/protontricks"
SRC_URI="https://github.com/Matoking/${PN}/archive/${COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui"

RDEPEND="
	app-emulation/winetricks[gui?]
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/vdf-3.4_p20240630[${PYTHON_USEDEP}]
	')
	gui? ( gnome-extra/zenity )"
BDEPEND="$(python_gen_cond_dep '
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
')"

DOCS=( CHANGELOG.md README.md )

distutils_enable_tests pytest

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
