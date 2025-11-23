# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unit-test framework for Bourne-based shell scripts"
HOMEPAGE="https://github.com/kward/shunit2"
SRC_URI="https://github.com/kward/shunit2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~riscv x86"

src_test() {
	SHELL="/bin/bash" ./test_runner -s /bin/bash || die "bash tests failed"
}

src_install() {
	dobin shunit2

	# For backwards compat to <=2.1.5
	dosym -r /usr/bin/shunit2 /usr/share/shunit2/shunit2

	dodoc -r examples
	dodoc doc/*.txt
}
