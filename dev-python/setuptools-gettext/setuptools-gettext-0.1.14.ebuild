# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Setuptools plugin for building mo files"
HOMEPAGE="
	https://pypi.org/project/setuptools-gettext/
	https://github.com/breezy-team/setuptools-gettext
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-devel/gettext
"

python_test() {
	cd example || die
	distutils_pep517_install "${T}/${EPYTHON}"
	if [[ ! -f ${T}/${EPYTHON}/usr/share/locale/nl/LC_MESSAGES/hallowereld.mo ]]
	then
		die ".mo file not installed"
	fi
}
