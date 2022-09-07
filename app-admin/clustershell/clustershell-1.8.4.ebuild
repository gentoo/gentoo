# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Python framework for efficient cluster administration"
HOMEPAGE="https://github.com/cea-hpc/clustershell/"
SRC_URI="
	https://github.com/cea-hpc/clustershell/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		app-shells/pdsh
		net-misc/openssh
		sys-devel/bc
	)
"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

PATCHES=(
	# python3.10 related fixes taken from upstream
	"${FILESDIR}/${P}-setrlimit-division.patch"
	"${FILESDIR}/${P}-current-thread.patch"

	"${FILESDIR}/${P}-skip-tests.patch"
)

distutils_enable_tests unittest

src_prepare() {
	default

	# remove test sets that require working ssh connection
	rm tests/{CLIClush,TaskDistant*,TreeWorker}Test.py || die
}

python_test() {
	cd tests || die
	# Automatic discovery does not work
	"${EPYTHON}" -m unittest_or_fail -v *.py || die "Tests failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	doman doc/man/man*/*

	mv "${ED}/usr/etc" "${ED}/etc" || die
}

pkg_postinst() {
	einfo "Some default system-wide config files have been installed into"
	einfo "/etc/${PN}"
}
