# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit cmake python-single-r1

DESCRIPTION="Python bindings for libnest2d"
HOMEPAGE="https://github.com/Ultimaker/pynest2d"
SRC_URI="https://github.com/Ultimaker/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libnest2d
	$(python_gen_cond_dep 'dev-python/sip[${PYTHON_MULTI_USEDEP}]')
	"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-required-flags-from-Libnest2D-target.patch" )

#	test? (  )
#	""

#DEPENDENCIES

# Clipper, a polygon clipping library.
# NLopt, a library to solve non-linear optimization problems.
# Boost, the headers only.
# Sip, an application to generate Python bindings more easily.
