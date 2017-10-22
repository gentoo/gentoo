# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )
inherit distutils-r1 flag-o-matic

DESCRIPTION="BLAKE2 hash function extension module"
HOMEPAGE="https://github.com/dchest/pyblake2 https://pypi.python.org/pypi/pyblake2"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="cpu_flags_x86_ssse3 cpu_flags_x86_avx cpu_flags_x86_xop"

python_prepare_all() {
	local impl=REGS
	# note: SSE2 is 2.5x slower than pure REGS, so we ignore it
	if use cpu_flags_x86_xop; then
		impl=XOP
		append-cflags $(test-flags-CC -mxop)
	elif use cpu_flags_x86_avx; then
		# this does not actually do anything but implicitly enabled SSE4.1...
		impl=AVX
		append-cflags $(test-flags-CC -mavx)
	elif use cpu_flags_x86_ssse3; then
		impl=SSSE3
		append-cflags $(test-flags-CC -mssse3)
	fi

	# uncomment the implementation of choice
	sed -i -e "/BLAKE2_COMPRESS_${impl}/s:^#::" setup.py || die

	# avoid segfault due to over(?) optimisation
	if [[ ${CHOST} == *86*-darwin* ]] ; then
		local march=$(get-flag march)
		# expand "native" into the used cpu optmisation
		if [[ ${march} == native ]] ; then
			# we're always on Clang here	
			march=$(llc --version | grep "Host CPU:")
			march=${march##*: }
		fi
		# compiling for haswell cpu results in a segfault when used
		# with optimisation >O1, since optimisation here benefits more
		# than cpu specific instructions, reduce to ivybridge level
		case ${march} in
			haswell|broadwell|skylake*)
				local opt=$(get-flag -O)
				[[ ${opt#-O} -gt 1 ]] && \
					replace-flags -march=* -march=ivybridge
				;;
		esac
	fi

	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" test/test.py || die "Tests fail with ${EPYTHON}"
}
