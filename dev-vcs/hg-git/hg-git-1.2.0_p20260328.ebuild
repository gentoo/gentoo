# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 multiprocessing

GIT_COMMIT="0b8fb9c9ceca65d48e1e0d848dab56fd7d64bb52"
MY_PV=${PV/_rc/a}
DESCRIPTION="push to and pull from a Git repository using Mercurial"
HOMEPAGE="https://hg-git.github.io https://pypi.org/project/hg-git/"
SRC_URI="https://foss.heptapod.net/mercurial/hg-git/-/archive/${GIT_COMMIT}/${PN}-${GIT_COMMIT}.tar.bz2"

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-vcs/mercurial-7.2[${PYTHON_USEDEP}]
	>=dev-python/dulwich-1.1.0[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		${RDEPEND}
		dev-vcs/git
	)
"

src_prepare() {
	default

	# remove some tests that just test codestyle, reducing dependencies
	rm tests/test-check-black.t || die
	rm tests/test-check-pyflakes.t || die
	rm tests/test-check-pylint.t || die
	# remove tests that cannot be run
	rm tests/test-check-commit.t || die
	rm tests/test-gitignore-windows.t || die
	rm tests/test-serve-ci.t || die
}

python_test() {
	cd tests || die

	"${EPYTHON}" run-tests.py \
		--jobs="$(makeopts_jobs "${MAKEOPTS}")" \
		--with-hg="${ESYSROOT}/usr/bin/hg" \
		|| die
}
