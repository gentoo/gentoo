# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="rdepend"
PYTHON_COMPAT=( python{2_7,3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="Gettext support, themed icons and scrollkeeper-based documentation in distutils"
HOMEPAGE="
	https://salsa.debian.org/python-team/modules/python-distutils-extra
	https://launchpad.net/python-distutils-extra"
SRC_URI="
	https://salsa.debian.org/python-team/modules/python-distutils-extra/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DOCS=( doc/{README,FAQ} )

BDEPEND="
	test? (
		dev-libs/gobject-introspection
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-util/intltool
	)"

PATCHES=(
	"${FILESDIR}"/python-distutils-extra-2.44-test.patch
	"${FILESDIR}"/python-distutils-extra-2.44-skip-build.patch
)

python_test() {
	unset PYTHONDONTWRITEBYTECODE
	"${EPYTHON}" test/auto.py -v || die "Tests fail with ${EPYTHON}"
}
