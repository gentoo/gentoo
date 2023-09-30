# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=ClusterShell
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="Python framework for efficient cluster administration"
HOMEPAGE="
	https://github.com/cea-hpc/clustershell/
	https://pypi.org/project/ClusterShell/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		app-shells/pdsh
		virtual/openssh
		sys-devel/bc
	)
"

distutils_enable_tests unittest

src_prepare() {
	default

	# remove test sets that require working ssh connection
	rm tests/{CLIClush,TaskDistant*}Test.py || die
}

python_test() {
	cd tests || die
	local runner=unittest_or_fail
	if [[ ${EPYTHON} == python3.12 ]]; then
		runner=unittest
	fi
	# Automatic discovery does not work
	"${EPYTHON}" -m "${runner}" -v *.py || die "Tests failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	einfo "Some default system-wide config files have been installed into"
	einfo "/etc/${PN}"
}
