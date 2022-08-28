# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Gettext support, themed icons and scrollkeeper-based documentation in distutils"
HOMEPAGE="
	https://salsa.debian.org/python-team/packages/python-distutils-extra/
	https://launchpad.net/python-distutils-extra/
"
SRC_URI="
	https://salsa.debian.org/python-team/packages/python-distutils-extra/-/archive/${PV}/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS=( doc/{README,FAQ} )

BDEPEND="
	test? (
		dev-libs/gobject-introspection
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-util/intltool
	)
"

python_test() {
	local -x SETUPTOOLS_USE_DISTUTILS=stdlib
	"${EPYTHON}" test/auto.py -v || die "Tests fail with ${EPYTHON}"
}
