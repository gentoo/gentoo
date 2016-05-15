# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils eutils flag-o-matic

DESCRIPTION="Checks and undeletes partitions + PhotoRec, signature based recovery tool"
HOMEPAGE="http://www.cgsecurity.org/wiki/TestDisk"
SRC_URI="http://www.cgsecurity.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86"
IUSE="ewf jpeg ntfs reiserfs static qt4"

REQUIRED_USE="static? ( !qt4 )"

# WARNING: reiserfs support does NOT work with reiserfsprogs
# you MUST use progsreiserfs-0.3.1_rc8 (the last version ever released).
DEPEND="
		static? (
			sys-apps/util-linux[static-libs]
			>=sys-libs/ncurses-5.2[static-libs]
			jpeg? ( virtual/jpeg:0[static-libs] )
			ntfs? ( sys-fs/ntfs3g[static-libs] )
			reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8[static-libs] )
			>=sys-fs/e2fsprogs-1.35[static-libs]
			sys-libs/zlib[static-libs]
			!arm? ( ewf? ( app-forensics/libewf:=[static-libs] ) )
			)
		!static? (
			sys-apps/util-linux
			>=sys-libs/ncurses-5.2
			jpeg? ( virtual/jpeg:0 )
			ntfs? ( sys-fs/ntfs3g )
			reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8 )
			>=sys-fs/e2fsprogs-1.35
			sys-libs/zlib
			!arm? ( ewf? ( app-forensics/libewf:= ) )
			qt4? ( dev-qt/qtgui:4 )
			)"
RDEPEND="!static? ( ${DEPEND} )"

AUTOTOOLS_IN_SOURCE_BUILD=1
DOCS=( )

src_configure() {
	local myconf

	# this is static method is the same used by upstream for their 'static' make
	# target, but better, as it doesn't break.
	use static && append-ldflags -static

	# --with-foo are broken, any use of --with/--without disable the
	# functionality.
	# The following variation must be used.
	use reiserfs || myconf+=" --without-reiserfs"
	use ntfs || myconf+=" --without-ntfs --without-ntfs3g"
	use jpeg || myconf+=" --without-jpeg"
	use ewf || myconf+=" --without-ewf"
	myconf+=$(usex qt4 " --enable-qt" " --disable-qt")

	econf \
		--docdir "${ROOT}/usr/share/doc/${P}" \
		--enable-sudo \
		${myconf}

	# perform safety checks for NTFS, REISERFS and JPEG
	if use ntfs && ! egrep -q '^#define HAVE_LIBNTFS(3G)? 1$' "${S}"/config.h ; then
		die "Failed to find either NTFS or NTFS-3G library."
	fi
	if use reiserfs && egrep -q 'undef HAVE_LIBREISERFS\>' "${S}"/config.h ; then
		die "Failed to find reiserfs library."
	fi
	if use jpeg && egrep -q 'undef HAVE_LIBJPEG\>' "${S}"/config.h ; then
		die "Failed to find jpeg library."
	fi
}
