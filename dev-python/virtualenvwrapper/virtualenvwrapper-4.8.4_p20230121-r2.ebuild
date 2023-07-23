# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="
	https://github.com/python-virtualenvwrapper/virtualenvwrapper
	https://pypi.org/project/virtualenvwrapper/
"

COMMIT="e63d2c389ed276aa161bb50a27c77af94d96a50c"
SRC_URI="
	https://github.com/python-virtualenvwrapper/virtualenvwrapper/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

export PBR_VERSION="${PV/_p/.post}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/stevedore[${PYTHON_USEDEP}]
		dev-python/virtualenv-clone[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/pbr[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/virtualenvwrapper-${PV}-remove-use-of-which.patch"
	"${FILESDIR}/virtualenvwrapper-${PV}-override-default-python-executable.patch"
)

src_prepare() {
	default

	# specify default python interpeter to align with PYTHON_SINGLE_TARGET
	sed -i -e "s:@@GENTOO_PYTHON_EXECUTABLE@@:${PYTHON}:" virtualenvwrapper.sh || die

	# remove tests which require an internet connection
	rm tests/test_mkvirtualenv_install.sh || die
	rm tests/test_mkvirtualenv_requirements.sh || die

	# remove tests which require functional git repos with remotes
	sed -i -e '/test_wipeenv_\(pip_e\|develop\) () {/,/}/ d' tests/test_wipeenv.sh || die
}

python_test() {
	# tests have unusual expectations
	local -x HOME="${HOME%/}"
	local -x USER="${USER}"

	cp -a "${BUILD_DIR}"/{install/usr,test} || die
	local -x VIRTUAL_ENV="${BUILD_DIR}/test"

	bash ./tests/run_tests "${VIRTUAL_ENV}" || die "Tests failed under ${EPYTHON}"
}
