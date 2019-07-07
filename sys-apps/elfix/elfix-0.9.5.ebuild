# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/elfix.git"
	inherit autotools git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/elfix/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86"
fi

DESCRIPTION="A suite of tools to work with ELF objects on Hardened Gentoo"
HOMEPAGE="https://www.gentoo.org/proj/en/hardened/pax-quickstart.xml
	https://dev.gentoo.org/~blueness/elfix/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+ptpax +xtpax"

DOCS=( AUTHORS ChangeLog INSTALL README THANKS TODO )

REQUIRED_USE="|| ( ptpax xtpax )"

# These only work with a properly configured PaX kernel
RESTRICT="test"

DEPEND="~dev-python/pypax-${PV}[ptpax=,xtpax=]
	ptpax? ( dev-libs/elfutils )
	xtpax? ( sys-apps/attr )"

RDEPEND="${DEPEND}"

src_prepare() {
	default
	if [[ ${PV} == *9999* ]]; then
		eautoreconf
		cd doc && ./make.sh || die
	fi
}

src_configure() {
	rm -f "${S}/scripts/setup.py"
	econf --disable-tests \
		$(use_enable ptpax) \
		$(use_enable xtpax)
}
