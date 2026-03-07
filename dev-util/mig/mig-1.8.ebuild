# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev

DESCRIPTION="GNU Mach 3.0 interface generator (IDL compiler)"
HOMEPAGE="https://www.gnu.org/software/hurd/microkernel/mach/mig/gnu_mig.html"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/mig.git"
	inherit autotools git-r3

	BDEPEND="
		sys-devel/bison
		sys-devel/flex
	"
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

	KEYWORDS="~x86"
fi

LICENSE="GPL-2 BSD-2"
SLOT="0"

if is_crosspkg ; then
	DEPEND+=" cross-${CTARGET}/gnumach"
fi

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	# Needs bison and flex
	unset YACC LEX

	local myeconfargs=(
		--prefix="${EPREFIX}${sysroot}/usr"
	)

	econf "${myeconfargs[@]}"
}
