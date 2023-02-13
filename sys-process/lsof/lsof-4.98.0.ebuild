# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

MY_P="${P/-/_}"
DESCRIPTION="Lists open files for running Unix processes"
HOMEPAGE="https://github.com/lsof-org/lsof"
SRC_URI="https://github.com/lsof-org/lsof/releases/download/${PV}/${P}.tar.gz"

LICENSE="lsof"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="rpc selinux"

RDEPEND="
	rpc? ( net-libs/libtirpc )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/groff
	rpc? ( virtual/pkgconfig )
"

# Needs fixing first for sandbox
RESTRICT="test"

src_configure() {
	export ac_cv_header_selinux_selinux_h=$(usex selinux)

	[[ ${CHOST} == *-solaris2.11 ]] && append-cppflags -DHAS_PAD_MUTEX

	local myeconfargs=(
		$(use_with rpc libtirpc)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake DEBUG="" all
}

pkg_postinst() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		einfo "Note: to use lsof on Solaris you need read permissions on"
		einfo "/dev/kmem, i.e. you need to be root, or to be in the group sys"
	elif [[ ${CHOST} == *-aix* ]] ; then
		einfo "Note: to use lsof on AIX you need read permissions on /dev/mem and"
		einfo "/dev/kmem, i.e. you need to be root, or to be in the group system"
	fi
}
