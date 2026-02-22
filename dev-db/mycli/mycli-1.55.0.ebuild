# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_VERIFY_REPO=https://github.com/dbcli/mycli
inherit distutils-r1 edo eapi9-ver multiprocessing pypi

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"
HOMEPAGE="
	https://www.mycli.net/
	https://github.com/dbcli/mycli/
	https://pypi.org/project/mycli/
"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# optional llm unpackaged
IUSE="ssh"

# ~paramiko-3.5.1: Pinned due to breakage. Feature soft deprecated for future removal
# https://github.com/dbcli/mycli/commit/82c7d92a16ad15906c46df14cc6e6ee0249609e6
# https://github.com/dbcli/mycli/issues/1464
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cli-helpers-2.10.1[${PYTHON_USEDEP}]
		>=dev-python/click-8.3.1[${PYTHON_USEDEP}]
		>=dev-python/configobj-5.0.9[${PYTHON_USEDEP}]
		>=dev-python/cryptography-46.0.5[${PYTHON_USEDEP}]
		>=dev-python/keyring-25.7.0[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.6[${PYTHON_USEDEP}]
		<dev-python/prompt-toolkit-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pycryptodome-3.23.0[${PYTHON_USEDEP}]
		>=dev-python/pyfzf-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.19.2[${PYTHON_USEDEP}]
		>=dev-python/pymysql-1.1.2[${PYTHON_USEDEP}]
		>=dev-python/pyperclip-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz-3.14.3[${PYTHON_USEDEP}]
		=dev-python/sqlglot-27*[${PYTHON_USEDEP}]
		<dev-python/sqlparse-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
		ssh? (
			~dev-python/paramiko-3.5.1[${PYTHON_USEDEP}]
			dev-python/sshtunnel[${PYTHON_USEDEP}]
		)
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		test? (
			dev-db/mysql[server]
			>=dev-python/behave-1.3.3[${PYTHON_USEDEP}]
			~dev-python/paramiko-3.5.1[${PYTHON_USEDEP}]
			>=dev-python/pexpect-4.9.0[${PYTHON_USEDEP}]
			dev-python/sshtunnel[${PYTHON_USEDEP}]
		)
	')
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

src_test() {
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

	EPYTEST_IGNORE=(
		# Requires unpackaged llm
		test/test_llm_special.py
		# AssertionError: assert 8 in [4, 5, 6, 7]
		# Per upstream: "...it is a flaky test at best."
		# https://github.com/dbcli/mycli/commit/3d08910a366d4505a40e8a0fb36c210330723f18
		test/test_special_iocommands.py::test_watch_query_full
	)

	local failures=()
	if ! nonfatal distutils-r1_src_test ; then
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
		die "Tests failed: ${failures}"
	fi
}

pkg_postinst() {
	if use ssh && ver_replacing -lt 1.49; then
		elog "The built-in SSH functionality has been soft deprecated in mycli."
		elog "It may be removed upstream in a future release and even sooner"
		elog "downstream in the ebuild due to the pinned paramiko dependency."
		elog "See also https://github.com/dbcli/mycli/issues/1464"
		elog ""
	fi
	if ver_replacing -lt 1.50; then
		elog "Reading configuration from '.my.cnf' has been deprecated."
		elog "Configuration should be done in '.myclirc' from now on,"
		elog "and in the future '.my.cnf' will be ignored."
		elog "See also https://github.com/dbcli/mycli/issues/1490"
		elog ""
	fi
}
