# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs gnome2-utils xdg-utils

DESCRIPTION="A fast, lightweight imageviewer using imlib2"
HOMEPAGE="https://feh.finalrewind.org/"
SRC_URI="https://feh.finalrewind.org/${P}.tar.bz2"

LICENSE="feh"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ppc64 x86"
IUSE="debug curl exif test xinerama"
RESTRICT="!test? ( test )"

COMMON_DEPEND="media-libs/imlib2[X]
	>=media-libs/libpng-1.2:0=
	x11-libs/libX11
	curl? ( net-misc/curl )
	exif? ( media-libs/libexif )
	xinerama? ( x11-libs/libXinerama )"
RDEPEND="${COMMON_DEPEND}
	virtual/jpeg:0"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	x11-libs/libXt
	test? (
		>=dev-lang/perl-5.10
		dev-perl/Test-Command
		media-libs/imlib2[gif,jpeg,png]
	)"

PATCHES=( "${FILESDIR}"/${PN}-3.2-debug-cflags.patch )

pkg_setup() {
	use_feh() { usex $1 1 0; }

	fehopts=(
		DESTDIR="${D}"
		PREFIX="${EPREFIX}"/usr
		doc_dir='${main_dir}'/share/doc/${PF}
		example_dir='${main_dir}'/share/doc/${PF}/examples
		curl=$(use_feh curl)
		debug=$(use_feh debug)
		xinerama=$(use_feh xinerama)
		exif=$(use_feh exif)
	)
}

src_compile() {
	tc-export CC
	emake "${fehopts[@]}"
}

src_install() {
	emake "${fehopts[@]}" install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
