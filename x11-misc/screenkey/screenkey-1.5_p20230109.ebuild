# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 xdg

DESCRIPTION="A screencast tool to display your keys inspired by Screenflick"
HOMEPAGE="https://www.thregr.org/~wavexx/software/screenkey/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/screenkey/${PN}.git"
else
	if [[ ${PV} == *_p20230109 ]] ; then
		H=7bdba66574244061c6e1934c4f204d02d570f182
		SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/${H}/${PN}-${H}.tar.bz2
			-> ${P}.tar.bz2"
		S="${WORKDIR}"/${PN}-${H}
	else
		SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
			-> ${P}.tar.bz2"
		S="${WORKDIR}"/${PN}-v${PV}
	fi
	KEYWORDS="amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="appindicator"
RESTRICT="test"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	media-fonts/fontawesome
	x11-libs/gtk+:3[X,introspection]
	x11-misc/slop
	appindicator? ( dev-libs/libayatana-appindicator )
"
BDEPEND="
	dev-python/Babel[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

src_prepare() {
	# Change the doc install path
	sed -i "s|share/doc/screenkey|share/doc/${PF}|g" setup.py || die

	default
}
