# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 systemd

DESCRIPTION="Automatically create, prune and verify backups with borgbackup"
HOMEPAGE="https://torsion.org/borgmatic/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"

# borg is called as an external tool, hence no pythonic stuff
RDEPEND="app-backup/borgbackup
	$(python_gen_cond_dep '
		<dev-python/colorama-0.5[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		<dev-python/ruamel-yaml-0.18.0[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			>=dev-python/flexmock-0.10.10[${PYTHON_USEDEP}]
		')
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.1-no_test_coverage.patch
	"${FILESDIR}"/${PN}-1.7.3-systemd_service_bin_path.patch
)

# A fragile test whose only purpose is to make sure the NEWS file
# has been updated for the current version.
EPYTEST_DESELECT=(
	tests/integration/commands/test_borgmatic.py::test_borgmatic_version_matches_news_version
)

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	systemd_dounit sample/systemd/borgmatic.{service,timer}
	keepdir /etc/borgmatic
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "To generate a sample configuration file, run:"
		elog "    generate-borgmatic-config"
	else
		ewarn "Please note that since version 1.7.0 ${PN} no longer supports old-style command-line action flags like '--create', '--list', etc."
		ewarn "Make sure all your scripts use actions, e.g. 'create', 'list' and so on"
	fi
	elog
	elog "Systemd users wishing to periodically run borgmatic can use the provided timer and service units."
}
