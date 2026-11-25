# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-single-r1

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/elfix.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/elfix/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Suite of tools to work with ELF objects on Hardened Gentoo"
HOMEPAGE="https://www.gentoo.org/proj/en/hardened/pax-quickstart.xml
	https://dev.gentoo.org/~blueness/elfix/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+ptpax test +xtpax"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( ptpax xtpax )
"
# These only work with a properly configured PaX kernel
RESTRICT="!test? ( test ) test"

DEPEND="$(python_gen_cond_dep "~dev-python/pypax-${PV}[ptpax=,xtpax=,\${PYTHON_USEDEP}]")
	ptpax? ( dev-libs/elfutils )
	xtpax? ( sys-apps/attr )"

RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

src_prepare() {
	default
	if [[ ${PV} == *9999* ]]; then
		eautoreconf
		cd doc && ./make.sh || die
	fi
}

src_configure() {
	rm -f "${S}/scripts/setup.py" || die
	econf \
		$(use_enable test tests) \
		$(use_enable ptpax) \
		$(use_enable xtpax)
}

src_install() {
	default
	python_fix_shebang "${ED}"
}
