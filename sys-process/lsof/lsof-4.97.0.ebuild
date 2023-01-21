# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

MY_P="${P/-/_}"
DESCRIPTION="Lists open files for running Unix processes"
HOMEPAGE="https://github.com/lsof-org/lsof"
SRC_URI="https://github.com/lsof-org/lsof/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="lsof"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
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

# Needs fixing first
RESTRICT="test"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	export ac_cv_header_rpc_rpc_h=$(usex rpc)
	export ac_cv_header_selinux_selinux_h=$(usex selinux)

	if use rpc ; then
		append-cppflags $($(tc-getPKG_CONFIG) libtirpc --cflags)
		append-libs $($(tc-getPKG_CONFIG) libtirpc --libs)
	fi

	[[ ${CHOST} == *-solaris2.11 ]] && append-cppflags -DHAS_PAD_MUTEX

	econf
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
