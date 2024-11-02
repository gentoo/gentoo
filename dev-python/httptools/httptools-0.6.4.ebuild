# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A collection of framework independent HTTP protocol utils"
HOMEPAGE="
	https://github.com/MagicStack/httptools/
	https://pypi.org/project/httptools/
"
# sdist is missing cython source files, as of 0.6.2
SRC_URI="
	https://github.com/MagicStack/httptools/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# don't ask me why they use both
DEPEND="
	net-libs/http-parser:=
	net-libs/llhttp:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_configure() {
	cat > setup.cfg <<-EOF || die
		[build_ext]
		use_system_llhttp = true
		use_system_http_parser = true
		cython_always = true
	EOF
}

python_test() {
	local EPYTEST_DESELECT=()

	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				# error message mismatches
				# https://github.com/MagicStack/httptools/issues/16#issuecomment-1114181747
				tests/test_parser.py::TestResponseParser::test_parser_response_2
				tests/test_parser.py::TestRequestParser::test_parser_request_4
				tests/test_parser.py::TestUrlParser::test_parser_url_10
			)
			;;
	esac

	rm -rf httptools || die
	epytest tests
}
