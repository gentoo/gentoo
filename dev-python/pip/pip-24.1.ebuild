# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# please bump dev-python/ensurepip-pip along with this package!

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{10..13} )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" pypy3 )
PYTHON_REQ_USE="ssl(+),threads(+)"

inherit bash-completion-r1 distutils-r1

DESCRIPTION="The PyPA recommended tool for installing Python packages"
HOMEPAGE="
	https://pip.pypa.io/en/stable/
	https://pypi.org/project/pip/
	https://github.com/pypa/pip/
"
SRC_URI="
	https://github.com/pypa/pip/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="MIT"
# bundled deps
LICENSE+=" Apache-2.0 BSD BSD-2 ISC LGPL-2.1+ MPL-2.0 PSF-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test-rust"

RDEPEND="
	>=dev-python/setuptools-39.2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/ensurepip-setuptools
			dev-python/ensurepip-wheel
			dev-python/freezegun[${PYTHON_USEDEP}]
			dev-python/pretend[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
			dev-python/scripttest[${PYTHON_USEDEP}]
			dev-python/tomli-w[${PYTHON_USEDEP}]
			dev-python/virtualenv[${PYTHON_USEDEP}]
			dev-python/werkzeug[${PYTHON_USEDEP}]
			dev-python/wheel[${PYTHON_USEDEP}]
			test-rust? (
				dev-python/cryptography[${PYTHON_USEDEP}]
			)
		' "${PYTHON_TESTED[@]}")
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/pip-23.1-no-coverage.patch"
		# https://github.com/pypa/pip/issues/12786 (and more)
		"${FILESDIR}/pip-24.1-test-offline.patch"
	)

	distutils-r1_python_prepare_all

	if use test; then
		local wheels=(
			"${BROOT}"/usr/lib/python/ensurepip/{setuptools,wheel}-*.whl
		)
		mkdir tests/data/common_wheels/ || die
		cp "${wheels[@]}" tests/data/common_wheels/ || die
	fi
}

python_compile_all() {
	# 'pip completion' command embeds full $0 into completion script, which confuses
	# 'complete' and causes QA warning when running as "${PYTHON} -m pip".
	# This trick sets correct $0 while still calling just installed pip.
	local pipcmd='import sys; sys.argv[0] = "pip"; __file__ = ""; from pip._internal.cli.main import main; sys.exit(main())'
	"${EPYTHON}" -c "${pipcmd}" completion --bash > completion.bash || die
	"${EPYTHON}" -c "${pipcmd}" completion --zsh > completion.zsh || die
}

python_test() {
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return 0
	fi

	local EPYTEST_DESELECT=(
		tests/functional/test_inspect.py::test_inspect_basic
		# Internet
		tests/functional/test_config_settings.py::test_backend_sees_config_via_sdist
		tests/functional/test_install.py::test_double_install_fail
		tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
	)
	local EPYTEST_IGNORE=(
		# requires proxy.py
		tests/functional/test_proxy.py
	)

	if ! has_version "dev-python/cryptography[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/functional/test_install.py::test_install_sends_client_cert
			tests/functional/test_install_config.py::test_do_not_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_authentication
			tests/functional/test_install_config.py::test_prompt_for_keyring_if_needed
		)
	fi

	case ${EPYTHON} in
		python3.10)
			EPYTEST_DESELECT+=(
				# no clue why they fail
				tests/unit/test_base_command.py::test_base_command_global_tempdir_cleanup
				tests/unit/test_base_command.py::test_base_command_local_tempdir_cleanup
				tests/unit/test_base_command.py::test_base_command_provides_tempdir_helpers
			)
			;;
	esac

	local -x PIP_DISABLE_PIP_VERSION_CHECK=1
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_XDIST=1
	epytest -m "not network" -o tmp_path_retention_policy=all
}

python_install_all() {
	local DOCS=( AUTHORS.txt docs/html/**/*.rst )
	distutils-r1_python_install_all

	newbashcomp completion.bash pip

	insinto /usr/share/zsh/site-functions
	newins completion.zsh _pip
}
