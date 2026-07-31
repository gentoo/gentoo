# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_VERIFY_REPO=https://github.com/dbcli/mycli
inherit distutils-r1 edo multiprocessing pypi shell-completion

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"
HOMEPAGE="
	https://www.mycli.net/
	https://github.com/dbcli/mycli/
	https://pypi.org/project/mycli/
"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# optional dataframe packages (altair and polars) unpackaged
# optional llm unpackaged

RDEPEND="
	>=dev-python/cli-helpers-2.15.1[${PYTHON_USEDEP}]
	>=dev-python/click-8.4.2[${PYTHON_USEDEP}]
	>=dev-python/clickdc-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.9[${PYTHON_USEDEP}]
	>=dev-python/cryptography-49.0.0[${PYTHON_USEDEP}]
	>=dev-python/keyring-25.7.0[${PYTHON_USEDEP}]
	<dev-python/prompt-toolkit-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-3.0.41[${PYTHON_USEDEP}]
	>=dev-python/pycryptodome-3.23.0[${PYTHON_USEDEP}]
	>=dev-python/pyfzf-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.19.2[${PYTHON_USEDEP}]
	>=dev-python/pymysql-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/rapidfuzz-3.14.3[${PYTHON_USEDEP}]
	>=dev-python/sqlglot-30.12.0[${PYTHON_USEDEP}]
	<dev-python/sqlparse-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/yaspin-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/wcwidth-0.8.2[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-db/mysql[server]
		>=dev-python/behave-1.3.3[${PYTHON_USEDEP}]
		>=dev-python/pexpect-4.9.0[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_prepare_all() {
	# no coverage please
	sed -e 's/import coverage ; coverage.process_startup(); //' \
		-i test/features/environment.py test/features/steps/wrappers.py || die

	# dont pin dependencies
	sed -e '/^dependencies = \[/,/^\]$/ s/"\(.*\) ~=/"\1 >=/' \
		-i pyproject.toml || die

	# convert from pycryptodomex to pycryptodome
	sed -e 's/pycryptodomex/pycryptodome/' -i pyproject.toml || die
	sed -e 's/from Cryptodome/from Crypto/' -i mycli/config.py || die

	# network-sandbox messes with these
	sed -e '/run mycli on localhost without port/i  @gentoo_skip' \
		-e '/run mycli on TCP host without port/i  @gentoo_skip' \
		-e '/run mycli without host and port/i  @gentoo_skip' \
		-i test/features/connection.feature || die

	# Requires an old school vi and the symlink for vi itself messes with this
	sed -e '/edit sql in file with external editor/i  @gentoo_skip' \
		-i test/features/iocommands.feature || die

	distutils-r1_python_prepare_all
}

python_test() {
	# test/utils.py
	local -x PYTEST_PASSWORD="notsecure"
	local -x PYTEST_HOST="127.0.0.1"
	local -x PYTEST_PORT="43307"
	local -x PYTEST_CHARSET="utf8"

	einfo "Creating mysql test instance ..."
	mysqld \
		--no-defaults \
		--initialize-insecure \
		--basedir="${EPREFIX}/usr" \
		--datadir="${T}/mysql" 1>"${T}"/mysql_install.log || die

	einfo "Starting mysql test instance ..."
	mysqld \
		--no-defaults \
		--character-set-server="${PYTEST_CHARSET}" \
		--bind-address="${PYTEST_HOST}" \
		--port="${PYTEST_PORT}" \
		--pid-file="${T}/mysqld.pid" \
		--socket="${T}/mysqld.sock" \
		--datadir="${T}/mysql" 1>"${T}/mysqld.log" 2>&1 &

	# wait for it to start
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] && break
		sleep 1
	done
	[[ ! -S ${T}/mysqld.sock ]] && die "mysqld failed to start"

	einfo "Configuring test mysql instance ..."
	mysql \
		-u root \
		--socket="${T}/mysqld.sock" \
		-e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${PYTEST_PASSWORD}'" \
		|| die "Failed to change mysql user password"

	EPYTEST_DESELECT=(
		# PyMysql 1.2 uses ssl if the server supports it
		"test/pytests/test_main.py::test_ssl_mode_off"
		# FIXME
		"test/pytests/test_zsh_completion.py::test_zsh_completion_lists_dsn_aliases_in_supported_contexts"
	)
	EPYTEST_IGNORE=(
		# Requires unpackaged llm
		"test/pytests/test_special_llm.py"
		# Requires unpackaged altairs and polars
		"test/pytests/test_polars_transform.py"
	)

	local failures=()
	if ! nonfatal epytest -o addopts= ; then
		failures+=( pytest )
	fi

	if ! nonfatal edo behave \
		--jobs=$(get_makeopts_jobs)  \
		--summary --verbose \
		--tags="not @gentoo_skip" \
		test/features ; then
		failures+=( behave )
	fi

	einfo "Stopping mysql test instance ..."
	pkill -F "${T}"/mysqld.pid || die
	# wait for it to stop
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] || break
		sleep 1
	done

	rm -rf "${T}"/mysql || die

	if [[ ${#failures[@]} -gt 0 ]]; then
		die "Tests failed with ${EPYTHON}: ${failures}"
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	dobashcomp mycli/resources/completions/bash/mycli
	dofishcomp mycli/resources/completions/fish/mycli.fish
	dozshcomp mycli/resources/completions/zsh/_mycli
}
