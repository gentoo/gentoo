# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit optfeature prefix python-any-r1

DESCRIPTION="A graphical front-end for GCC's coverage testing tool gcov"
HOMEPAGE="https://github.com/linux-test-project/lcov"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/linux-test-project/lcov.git"
	inherit git-r3
else
	SRC_URI="https://github.com/linux-test-project/lcov/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# Python is used for spreadsheet.py
RDEPEND="
	dev-lang/perl
	dev-perl/Capture-Tiny
	dev-perl/DateTime
	dev-perl/Devel-Cover
	|| (
		dev-perl/JSON-XS
		dev-perl/Cpanel-JSON-XS
		dev-perl/JSON
	)
	dev-perl/Memory-Process
	dev-perl/TimeDate
	dev-perl/PerlIO-gzip
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-perl/GD
		$(python_gen_any_dep '
			dev-python/coverage[${PYTHON_USEDEP}]
			dev-python/xlsxwriter[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version "dev-python/coverage[${PYTHON_USEDEP}]" \
		&& \
	python_has_version "dev-python/xlsxwriter[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# Disable failing tests for now
	# https://github.com/linux-test-project/lcov/issues/378
	# https://github.com/linux-test-project/lcov/issues/380
	sed \
		-e 's, extract/,,' \
		-e 's, mcdc$,,' \
		-i.bak tests/lcov/Makefile || die
	# https://github.com/linux-test-project/lcov/issues/381
	sed \
		-e 's, gendiffcov,,' \
		-e 's, py2lcov,,' \
		-i.bak tests/Makefile || die

	default
	if use prefix; then
		hprefixify bin/*.{pl,sh}
	fi
}

src_compile() { :; }

src_test() {
	emake -j1 check
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		CFG_DIR="${EPREFIX}/etc" \
		PREFIX="${EPREFIX}/usr" \
		LCOV_PERL_PATH="${EPREFIX}/usr/bin/perl" \
		install
}

pkg_postinst() {
	optfeature_header "Optional outuput support:"
	optfeature "png output support" dev-perl/GD[png]
	optfeature "spreadsheet output support" dev-python/xlsxwriter
	optfeature_header "Optional language support:"
	optfeature "Python code coverage support" dev-python/coverage
	optfeature "Perl code coverage support" dev-perl/Devel-Cover
}
