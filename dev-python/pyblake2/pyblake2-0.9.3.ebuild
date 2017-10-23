# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )
inherit distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="BLAKE2 hash function extension module"
HOMEPAGE="https://github.com/dchest/pyblake2 https://pypi.python.org/pypi/pyblake2"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

blake2_impl() {
	local code='
#if defined(__XOP__)
	HAVE_XOP
#elif defined(__AVX__)
	HAVE_AVX
#elif defined(__SSSE3__)
	HAVE_SSSE3
#elif defined(__SSE2__)
	HAVE_SSE2
#endif
'
	local res=$($(tc-getCC) -E -P ${CFLAGS} - <<<"${code}")

	case ${res} in
		*HAVE_XOP*)    echo XOP;;
		# this does not actually do anything but implicitly enabled SSE4.1...
		*HAVE_AVX*)    echo AVX;;
		*HAVE_SSSE3*)  echo SSSE3;;
		# note: SSE2 is 2.5x slower than pure REGS, so we ignore it
		#*HAVE_SSE2*)  echo SSE2;;
		*)             echo REGS;;
	esac
}

python_prepare_all() {
	# uncomment the implementation of choice
	sed -i -e "/BLAKE2_COMPRESS_$(blake2_impl)/s:^#::" setup.py || die

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
