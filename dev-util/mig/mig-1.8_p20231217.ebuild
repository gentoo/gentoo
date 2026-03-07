# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic

DESCRIPTION="GNU Mach 3.0 interface generator (IDL compiler)"
HOMEPAGE="https://www.gnu.org/software/hurd/microkernel/mach/mig/gnu_mig.html"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/hurd/mig.git"
	inherit autotools git-r3

	BDEPEND="
		sys-devel/bison
		sys-devel/flex
	"
elif [[ ${PV} == *_p* ]] ; then
	MY_PV=${PV%_p*}+git${PV#*_p}
	MY_P=${PN}_${MY_PV}

	# savannah doesn't allow snapshot downloads from cgit as of 2026-03,
	# but the Debian maintainer is also upstream, so just use theirs
	# instead.
	SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${MY_P}.orig.tar.xz"
	S="${WORKDIR}"/${MY_P/_/-}
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"
fi

LICENSE="GPL-2 BSD-2"
SLOT="0"
[[ ${PV} != 9999 ]] && KEYWORDS="~amd64 ~x86"

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

	# Fixed in master
	append-cflags -std=gnu17

	local myeconfargs=(
		--prefix="${EPREFIX}${sysroot}/usr"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if target_is_not_host ; then
		# Don't install docs when building a cross-mig
		rm -rf "${ED}"/usr/share/{doc,man,info,locale} || die
	fi
}
