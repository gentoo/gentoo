# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wavpack/wavpack-4.60.1-r1.ebuild,v 1.14 2015/01/29 18:57:06 mgorny Exp $

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
inherit autotools-multilib

DESCRIPTION="WavPack audio compression tools"
HOMEPAGE="http://www.wavpack.com"
SRC_URI="http://www.wavpack.com/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="cpu_flags_x86_mmx static-libs"

RDEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r4
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"

DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )

src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_x86_mmx mmx)
	)

	autotools-multilib_src_configure
}
