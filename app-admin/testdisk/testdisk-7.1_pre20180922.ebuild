# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_COMMIT=6837474129968d7de13d91e5454bd824c9136e73
inherit autotools flag-o-matic gnome2-utils

DESCRIPTION="Checks and undeletes partitions + PhotoRec, signature based recovery tool"
HOMEPAGE="https://www.cgsecurity.org/wiki/TestDisk"
SRC_URI="https://git.cgsecurity.org/cgit/${PN}/snapshot/${PN}-${EGIT_COMMIT}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE="ewf jpeg ntfs qt5 reiserfs static zlib"

REQUIRED_USE="static? ( !qt5 )"

# WARNING: reiserfs support does NOT work with reiserfsprogs
# you MUST use progsreiserfs-0.3.1_rc8 (the last version ever released).
COMMON_DEPEND="
	static? (
		sys-apps/util-linux[static-libs]
		sys-fs/e2fsprogs[static-libs]
		sys-libs/ncurses:0[static-libs]
		jpeg? ( virtual/jpeg:0[static-libs] )
		ntfs? ( sys-fs/ntfs3g:=[static-libs] )
		reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8[static-libs] )
		zlib? ( sys-libs/zlib[static-libs] )
		!arm? ( ewf? ( app-forensics/libewf:=[static-libs] ) )
	)
	!static? (
		sys-apps/util-linux
		sys-fs/e2fsprogs
		sys-libs/ncurses:0=
		jpeg? ( virtual/jpeg:0 )
		ntfs? ( sys-fs/ntfs3g )
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
		reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8 )
		zlib? ( sys-libs/zlib )
		!arm? ( ewf? ( app-forensics/libewf:= ) )
	)
"
DEPEND="${COMMON_DEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"
RDEPEND="!static? ( ${COMMON_DEPEND} )"

DOCS=( )

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-sudo
		--without-ntfs
		$(use_with ewf)
		$(use_with jpeg)
		$(use_with ntfs ntfs3g)
		$(use_enable qt5 qt)
		$(use_with reiserfs)
		$(use_with zlib)
	)

	# this static method is the same used by upstream for their 'static' make
	# target, but better, as it doesn't break.
	use static && append-ldflags -static

	econf "${myeconfargs[@]}"

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

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
