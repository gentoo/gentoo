# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 systemd pypi

DESCRIPTION="Automatically create, prune and verify backups with borgbackup"
HOMEPAGE="https://torsion.org/borgmatic/"

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
	"${FILESDIR}"/${PN}-1.7.3-systemd_service_bin_path.patch
	"${FILESDIR}"/${PN}-1.7.13-no_test_coverage.patch
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
		local oldver
		for oldver in ${REPLACING_VERSIONS}; do
			if ver_test "${oldver}" -lt 1.7.11; then
				ewarn "Since version 1.7.11 ${PN} defaults to a different way of selecting archives for multi-archive actions."
				ewarn "For details, please see"
				ewarn
				ewarn "	https://torsion.org/borgmatic/docs/how-to/make-per-application-backups/#archive-naming"
				ewarn
				break
			fi
		done
	fi
	elog
	elog "Systemd users wishing to periodically run borgmatic can use the provided timer and service units."
}
