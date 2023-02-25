# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 virtualx xdg

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/otsaloma/nfoview.git"
	inherit git-r3
else
	SRC_URI="https://github.com/otsaloma/nfoview/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple viewer for NFO files, which are ASCII art in the CP437 codepage"
HOMEPAGE="https://otsaloma.io/nfoview/"

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="${PYTHON_DEPS}
	sys-devel/gettext"
DEPEND="dev-python/pygobject:3[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	media-fonts/cascadia-code
	x11-libs/gtk+:3[introspection]"

EPYTEST_DESELECT=(
	"nfoview/test/test_util.py::TestModule::test_show_uri__unix"
	"nfoview/test/test_util.py::TestModule::test_show_uri__windows"
)

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}
