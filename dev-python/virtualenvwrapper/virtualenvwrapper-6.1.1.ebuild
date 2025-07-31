# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Set of extensions to Ian Bicking's virtualenv tool"
HOMEPAGE="
	https://github.com/python-virtualenvwrapper/virtualenvwrapper/
	https://pypi.org/project/virtualenvwrapper/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/stevedore[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-python/virtualenv-clone[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/pip[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}/virtualenvwrapper-6.0.0-remove-use-of-which.patch"
	"${FILESDIR}/virtualenvwrapper-4.8.4_p20230121-override-default-python-executable.patch"
)

src_prepare() {
	default

	# specify default python interpeter to align with PYTHON_SINGLE_TARGET
	sed -i -e "s:@@GENTOO_PYTHON_EXECUTABLE@@:${PYTHON}:" virtualenvwrapper.sh || die

	# remove tests which require an internet connection + bug #936086
	rm tests/test_mkvirtualenv_install.sh || die
	rm tests/test_mkvirtualenv_requirements.sh || die
	sed -i -e '/test_new_env_activated () {/,/}/ d' tests/test_cp.sh || die
	sed -i -e '/test_wipeenv () {/,/}/ d' tests/test_wipeenv.sh || die

	# remove tests which require functional git repos with remotes
	sed -i -e '/test_wipeenv_\(pip_e\|develop\) () {/,/}/ d' tests/test_wipeenv.sh || die
}

python_test() {
	# tests have unusual expectations
	local -x HOME="${HOME%/}"
	local -x USER="${USER}"
	local -x USING_TOX=1

	# Make sure that users env doesn't leak to tests
	unset VIRTUALENVWRAPPER_SCRIPT
	unset _VIRTUALENVWRAPPER_API

	local old_path="${PATH}"

	# Tests are based on how upstream tox handles it

	cp -a "${BUILD_DIR}"/{install/usr,test_bash} || die
	local -x VIRTUAL_ENV="${BUILD_DIR}/test_bash"
	touch "${VIRTUAL_ENV}"/bin/activate || die # silence warning

	local -x PATH="${VIRTUAL_ENV}/bin:${old_path}"
	local -x SHELL="/bin/bash"
	local -x test_shell_opts=

	bash ./tests/run_tests "${VIRTUAL_ENV}" || die "Tests failed under ${EPYTHON} with bash"

	if has_version app-shells/zsh; then
		cp -a "${BUILD_DIR}"/{install/usr,test_zsh} || die
		local -x VIRTUAL_ENV="${BUILD_DIR}/test_zsh"
		touch "${VIRTUAL_ENV}"/bin/activate || die # silence warning

		local -x PATH="${VIRTUAL_ENV}/bin:${old_path}"
		local -x SHELL="/bin/zsh"
		local -x test_shell_opts="-o shwordsplit"

		zsh -o shwordsplit ./tests/run_tests "${VIRTUAL_ENV}" || die "Tests failed under ${EPYTHON} with zsh"
	fi
}
