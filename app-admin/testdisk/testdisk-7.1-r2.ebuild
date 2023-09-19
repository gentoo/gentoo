# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg-utils

DESCRIPTION="Checks and undeletes partitions + PhotoRec, signature based recovery tool"
HOMEPAGE="https://www.cgsecurity.org/wiki/TestDisk"
SRC_URI="https://www.cgsecurity.org/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv x86"
IUSE="ewf jpeg ntfs gui reiserfs static zlib"

REQUIRED_USE="static? ( !gui )"

# WARNING: reiserfs support does NOT work with reiserfsprogs
# you MUST use progsreiserfs-0.3.1_rc8 (the last version ever released).
DEPEND="
	static? (
		sys-apps/util-linux[static-libs]
		sys-fs/e2fsprogs[static-libs]
		sys-libs/ncurses:0[static-libs]
		jpeg? ( media-libs/libjpeg-turbo:=[static-libs] )
		ntfs? ( sys-fs/ntfs3g[static-libs] )
		reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8[static-libs] )
		zlib? ( sys-libs/zlib[static-libs] )
		!arm? ( ewf? ( app-forensics/libewf[static-libs] ) )
	)
	!static? (
		sys-apps/util-linux
		sys-fs/e2fsprogs
		sys-libs/ncurses:0=
		jpeg? ( media-libs/libjpeg-turbo:= )
		ntfs? ( sys-fs/ntfs3g:= )
		gui? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
		reiserfs? ( >=sys-fs/progsreiserfs-0.3.1_rc8 )
		zlib? ( sys-libs/zlib )
		!arm? ( ewf? ( app-forensics/libewf:= ) )
	)
"
RDEPEND="!static? ( ${DEPEND} )"
BDEPEND="gui? ( dev-qt/linguist-tools:5 )"

DOCS=()

PATCHES=(
	"${FILESDIR}"/${P}-backport-ntfs-3g-ioctl-prototype.patch
)

src_configure() {
	export MOC="$(qt5_get_bindir)/moc"
	export PATH="$(qt5_get_bindir):${PATH}"

	local myconf=(
		--enable-sudo
		--without-ntfs
		$(use_with ewf)
		$(use_with jpeg)
		$(use_with ntfs ntfs3g)
		$(use_enable gui qt)
		$(use_with reiserfs)
		$(use_with zlib)
	)

	# this static method is the same used by upstream for their 'static' make
	# target, but better, as it doesn't break.
	use static && append-ldflags -static

	econf "${myconf[@]}"

	# perform safety checks for NTFS, REISERFS and JPEG
	if use ntfs && ! grep -E -q '^#define HAVE_LIBNTFS(3G)? 1$' "${S}"/config.h ; then
		die "Failed to find either NTFS or NTFS-3G library."
	fi
	if use reiserfs && grep -E -q 'undef HAVE_LIBREISERFS\>' "${S}"/config.h ; then
		die "Failed to find reiserfs library."
	fi
	if use jpeg && grep -E -q 'undef HAVE_LIBJPEG\>' "${S}"/config.h ; then
		die "Failed to find jpeg library."
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
