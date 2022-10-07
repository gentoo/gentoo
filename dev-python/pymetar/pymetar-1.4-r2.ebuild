# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Downloads and decodes to the weather report for a given station ID"
HOMEPAGE="https://www.schwarzvogel.de/software/pymetar/"
SRC_URI="https://www.schwarzvogel.de/pkgs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~x86"

src_test() {
	pushd testing/smoketest || die
	tar xzf reports.tgz || die
	distutils-r1_src_test
	popd || die
}

python_test() {
	# A failed tests does not necessarily cause a failure exit code
	# Check output manually, each test should show "reports check out ok"
	./runtests.sh || die "Tests failed with ${EPYTHON}"
}

src_install() {
	dodoc "${S}/README.md" "${S}/THANKS"
	doman "${S}/pymetar.1"

	distutils-r1_src_install
}
