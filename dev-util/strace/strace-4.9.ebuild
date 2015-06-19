# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/strace/strace-4.9.ebuild,v 1.10 2015/04/13 08:21:31 ago Exp $

EAPI="4"

inherit flag-o-matic eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://strace.git.sourceforge.net/gitroot/strace/strace"
	inherit git-2 autotools
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux"
fi

DESCRIPTION="A useful diagnostic, instructional, and debugging tool"
HOMEPAGE="http://sourceforge.net/projects/strace/"

LICENSE="BSD"
SLOT="0"
IUSE="aio +perl static"

# strace only uses the header from libaio to decode structs
DEPEND="aio? ( >=dev-libs/libaio-0.3.106 )
	sys-kernel/linux-headers"
RDEPEND=""

src_prepare() {
	if epatch_user || [[ ! -e configure ]] ; then
		# git generation
		./xlat/gen.sh
		eautoreconf
		[[ ! -e CREDITS ]] && cp CREDITS{.in,}
	fi

	filter-lfs-flags # configure handles this sanely
	use static && append-ldflags -static

	export ac_cv_header_libaio_h=$(usex aio)
}

src_install() {
	default
	use perl || rm "${ED}"/usr/bin/strace-graph
	dodoc CREDITS
}
