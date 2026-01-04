# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ADA_COMPAT=( gcc_{12..16} )
PYTHON_COMPAT=( python3_{11..14} )

inherit ada python-any-r1 multiprocessing

SpecV=0.31.2
SpecN="commonmark-spec"
Spec=${SpecN}-${SpecV}

DESCRIPTION="Provides a markdown parser written in Ada"
HOMEPAGE="https://github.com/AdaCore/markdown"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	test? (
		https://github.com/commonmark/${SpecN}/archive/refs/tags/${SpecV}.tar.gz
		-> ${Spec}.tar.gz
	)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="test"

RDEPEND="${ADA_DEPS}
	dev-ada/gprbuild[${ADA_USEDEP}]
	dev-ada/vss-text[${ADA_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
	ada_pkg_setup
}

src_prepare() {
	if use test; then
		mv ../${Spec} ${SpecN} || die
		sed -i -e "s|python3|python|" Makefile || die
	fi
	default
}

src_compile() {
	gprbuild -v -p -j$(makeopts_jobs) -XBUILD_MODE=dev gnat/markdown.gpr \
		-cargs ${ADAFLAGS} || die
	if use test; then
		gprbuild -v -p -j$(makeopts_jobs) -XBUILD_MODE=dev -aP gnat \
			-P gnat/tests/commonmark_tests.gpr -cargs ${ADAFLAGS} || die
	fi
}

src_test() {
	cd commonmark-spec
	${EPYTHON} test/spec_tests.py --program ../.objs/static/tests/commonmark_tests |\
		grep -E "^Example|^[0-9]+.passed" |\
		tee markdown_tests_result | tail
	cd ..
	diff -u testsuite/commonmark/xfails.txt \
		commonmark-spec/markdown_tests_result \
		&& die
}
