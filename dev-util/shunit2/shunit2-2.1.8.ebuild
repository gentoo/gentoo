# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unit-test framework for Bourne-based shell scripts"
HOMEPAGE="https://github.com/kward/shunit2"
SRC_URI="https://github.com/kward/shunit2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-shells/dash
		app-shells/ksh
		app-shells/zsh
	)
"

src_test() {
	rm shunit2_macros_test.sh || die
	./test_runner || die
}

src_install() {
	dobin shunit2

	# For backwards compat to <=2.1.5
	dosym -r /usr/bin/shunit2 /usr/share/shunit2/shunit2

	dodoc -r examples
	dodoc doc/*.txt
}
