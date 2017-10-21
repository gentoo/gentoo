# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )
inherit distutils-r1

DESCRIPTION="BLAKE2 hash function extension module"
HOMEPAGE="https://github.com/dchest/pyblake2 https://pypi.python.org/pypi/pyblake2"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cpu_flags_x86_ssse3 cpu_flags_x86_avx cpu_flags_x86_xop"

python_prepare_all() {
	local impl=REGS
	# note: SSE2 is 2.5x slower than pure REGS, so we ignore it
	use cpu_flags_x86_ssse3 && impl=SSSE3
	# this does not actually do anything but implicitly enabled SSE4.1...
	use cpu_flags_x86_avx && impl=AVX
	use cpu_flags_x86_xop && impl=XOP

	# uncomment the implementation of choice
	sed -i -e "/BLAKE2_COMPRESS_${impl}/s:^#::" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" test/test.py || die "Tests fail with ${EPYTHON}"
}
