# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="CLI for MySQL Database with auto-completion and syntax highlighting"
HOMEPAGE="
	https://www.mycli.net/
	https://github.com/dbcli/mycli/
	https://pypi.org/project/mycli/
"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="ssh"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cli-helpers-2.2.1[${PYTHON_USEDEP}]
		>=dev-python/click-7.0[${PYTHON_USEDEP}]
		>=dev-python/configobj-5.0.5[${PYTHON_USEDEP}]
		>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/prompt-toolkit-3.0.6[${PYTHON_USEDEP}]
		<dev-python/prompt-toolkit-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyaes-1.6.1[${PYTHON_USEDEP}]
		>=dev-python/pyfzf-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
		>=dev-python/pymysql-0.9.2[${PYTHON_USEDEP}]
		>=dev-python/pyperclip-1.8.1[${PYTHON_USEDEP}]
		>=dev-python/sqlglot-5.1.3[${PYTHON_USEDEP}]
		<dev-python/sqlparse-0.6.0[${PYTHON_USEDEP}]
		>=dev-python/sqlparse-0.3.0[${PYTHON_USEDEP}]
		ssh? (
			dev-python/paramiko[${PYTHON_USEDEP}]
			dev-python/sshtunnel[${PYTHON_USEDEP}]
		)
	')
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
		test? (
			dev-db/mysql[server]
			dev-python/paramiko[${PYTHON_USEDEP}]
		)
	')
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

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

	nonfatal distutils-r1_src_test
	local ret=${?}

	einfo "Stopping mysql test instance ..."
	pkill -F "${T}"/mysqld.pid || die
	# wait for it to stop
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] || break
		sleep 1
	done

	rm -rf "${T}"/mysql || die

	[[ ${ret} -ne 0 ]] && die
}
