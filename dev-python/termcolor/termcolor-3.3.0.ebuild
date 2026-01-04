# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/termcolor/termcolor
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="ANSI Color formatting for output in terminal"
HOMEPAGE="
	https://github.com/termcolor/termcolor/
	https://pypi.org/project/termcolor/
"
# rename is for avoiding conflict with dev-cpp/termcolor
SRC_URI="
	$(pypi_sdist_url) -> ${P}.py.tar.gz
	$(pypi_provenance_url "${P}.tar.gz") -> ${P}.py.tar.gz.provenance
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_unpack() {
	if use verify-provenance; then
		cp "${DISTDIR}/${P}.py.tar.gz" "${WORKDIR}/${P}.tar.gz" || die
		pypi_verify_provenance "${WORKDIR}/${P}.tar.gz" \
			"${DISTDIR}/${P}.py.tar.gz.provenance"
	fi

	default
}
