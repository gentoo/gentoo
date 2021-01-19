# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="app-emulation/winetricks wrapper for Proton (Steam Play) games"
HOMEPAGE="https://github.com/Matoking/protontricks"
SRC_URI="https://github.com/Matoking/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gui"

RDEPEND="app-emulation/winetricks
	$(python_gen_cond_dep '
		dev-python/vdf[${PYTHON_USEDEP}]
	')
	gui? ( gnome-extra/zenity
		|| (
			app-emulation/winetricks[gtk]
			app-emulation/winetricks[kde]
		)
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.3_no-setuptools-scm.patch
)

DOCS=( CHANGELOG.md README.md )

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	echo "version = '${PV}'" > "${S}"/src/${PN}/_version.py || die "Failed to generate the version file"
}

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
