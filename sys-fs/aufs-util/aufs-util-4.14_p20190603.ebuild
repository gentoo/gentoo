# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-info multilib toolchain-funcs

DESCRIPTION="Utilities are always necessary for aufs"
HOMEPAGE="http://aufs.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"
# git archive -v --prefix=${P}/ --remote=git://git.code.sf.net/p/aufs/aufs-util aufs4.14 -o ${P}.tar
# xz -ve9 *.tar

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	!sys-fs/aufs2
	!<sys-fs/aufs3-3_p20130318"
DEPEND="${RDEPEND}
	~sys-fs/aufs-headers-${PV}"

src_prepare() {
	sed \
		-e "/LDFLAGS += -static -s/d" \
		-e "/CFLAGS/s:-O::g" \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		-i Makefile || die

	sed \
		-e '/LDFLAGS/s: -s::g' \
		-e "s:m 644 -s:m 644:g" \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		-i libau/Makefile || die

	sed \
		-e '/LDFLAGS/s: -s::g' \
		-e '/LDLIBS/s:-lrt::g' \
		-e '/LDLIBS/s:$: -lrt:g' \
		-i fhsm/Makefile || die

	tc-export CC AR
	export HOSTCC=$(tc-getCC)
	export STRIP=true
	default
}
