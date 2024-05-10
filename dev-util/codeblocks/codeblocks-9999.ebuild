# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit autotools flag-o-matic multiprocessing subversion wxwidgets xdg

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="https://codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}/code/trunk"
ESVN_FETCH_CMD="svn checkout --ignore-externals"
ESVN_UPDATE_CMD="svn update --ignore-externals"

IUSE="contrib debug"

BDEPEND="virtual/pkgconfig"

RDEPEND="app-arch/zip
	dev-libs/glib:2
	>=dev-libs/tinyxml-2.6.2-r3
	>=dev-util/astyle-3.1-r2:0/3.1
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-admin/gamin
		app-arch/bzip2
		app-text/hunspell:=
		dev-libs/boost:=
		dev-libs/libgamin
		media-libs/fontconfig
		sys-libs/zlib
	)"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=( "${FILESDIR}/${P}-nodebug.diff" )

src_prepare() {
	default
	# Let's make the autorevision work.
	subversion_wc_info
	CB_LCD=$(LC_ALL=C svn info "${ESVN_WC_PATH}" | grep "^Last Changed Date:" | cut -d" " -f4,5)
	echo "m4_define([SVN_REV], ${ESVN_WC_REVISION})" > revision.m4
	echo "m4_define([SVN_DATE], ${CB_LCD})" >> revision.m4
	eautoreconf
}

src_configure() {
	# Bug 858338
	append-flags -fno-strict-aliasing

	setup-wxwidgets

	local myeconfargs=(
		--disable-pch
		--disable-static
		$(use_enable debug)
		$(use_with contrib boost-libdir "${ESYSROOT}/usr/$(get_libdir)")
		$(use_with contrib contrib-plugins all)
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	if use contrib; then
		if (( $(get_makeopts_jobs) > 8 )); then
			emake -j8  # Bug 930819
		else
			emake
		fi
	else
		emake
	fi
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
