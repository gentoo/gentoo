# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

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
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.2.1[${PYTHON_USEDEP}]
	' 3.10)
"

PATCHES=(
	# https://github.com/breezy-team/setuptools-gettext/pull/31
	"${FILESDIR}/${P}-wheel.patch"
)

python_test() {
	cd example || die
	distutils_pep517_install "${T}/${EPYTHON}"
	if [[ ! -f ${T}/${EPYTHON}/usr/share/locale/nl/LC_MESSAGES/hallowereld.mo ]]
	then
		die ".mo file not installed"
	fi
}
