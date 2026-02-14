# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 eapi9-ver systemd

DESCRIPTION="Automatically create, prune and verify backups with borgbackup"
HOMEPAGE="
	https://torsion.org/borgmatic/
	https://projects.torsion.org/borgmatic-collective/borgmatic
"
# tests are not present in pypi archive since version 2.0.8
SRC_URI="
	https://github.com/borgmatic-collective/borgmatic/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv"
IUSE="apprise"

# borg is called as an external tool, hence no pythonic stuff
RDEPEND="
	app-backup/borgbackup
	$(python_gen_cond_dep '
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	')
	apprise? ( $(python_gen_cond_dep '
		dev-python/apprise[${PYTHON_USEDEP}]
	') )
"
BDEPEND="
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/apprise[${PYTHON_USEDEP}]
			>=dev-python/flexmock-0.10.10[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.14-systemd_service_bin_path.patch
	"${FILESDIR}"/${PN}-1.9.3-no_test_coverage.patch
)

EPYTEST_DESELECT=(
	# A fragile test whose only purpose is to make sure the NEWS file
	# has been updated for the current version.
	tests/integration/commands/test_borgmatic.py::test_borgmatic_version_matches_news_version

	# data_source tests were ommited in the pypi archive, they are present in
	# git archive, but they fail in py3.14.
	# See https://projects.torsion.org/borgmatic-collective/borgmatic/issues/1149
	tests/unit/hooks/data_source/test_dump.py::test_convert_glob_patterns_to_borg_pattern_makes_multipart_regular_expression
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
		elog "    ${PN} config generate"
		elog
		elog "Systemd users wishing to periodically run ${PN} can use the provided timer and service units."
	elif ver_replacing -lt 2.1.0; then
		ewarn "Please be warned that ${PN}-2.1.0 has introduced several breaking changes."
		ewarn "For details, please see"
		ewarn
		ewarn "	https://github.com/borgmatic-collective/borgmatic/releases/tag/2.1.0"
		ewarn
	fi
}
