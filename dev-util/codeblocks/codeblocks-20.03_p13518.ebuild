# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit autotools flag-o-matic multiprocessing wxwidgets xdg

REV=13518
REV_DATE="2024-05-05 20:30:28"
FP_NAME=fortranproject
FP_REV=378

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="https://codeblocks.org/"

# svn export --ignore-externals https://svn.code.sf.net/p/codeblocks/code/trunk@${REV} codeblocks-20.03_p${REV}
# tar -cjf codeblocks-20.03_p${REV}.tar.bz2 codeblocks-20.03_p${REV}
#
# svn export https://svn.code.sf.net/p/fortranproject/code/trunk@${FP_REV} fortranproject_r${FP_REV}
# tar -cjf fortranproject_r${FP_REV}.tar.bz2 fortranproject_r${FP_REV}
SRC_URI="
	https://github.com/band-a-prend/gentoo-overlay/releases/download/${PN}-20.03_p${REV}/${PN}-20.03_p${REV}.tar.bz2
	https://github.com/band-a-prend/gentoo-overlay/releases/download/${PN}-20.03_p${REV}/${FP_NAME}_r${FP_REV}.tar.bz2
"

LICENSE="GPL-3"
SLOT="0"

IUSE="fortran contrib debug"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	app-arch/zip
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
	)
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}/${PN}-9999-nodebug.diff"
	"${FILESDIR}/${P}_FortranProject-r378-autotools-build.patch"
)

src_unpack() {
	default
	mv -T "${WORKDIR}/${FP_NAME}_r${FP_REV}" "${S}"/src/plugins/contrib/FortranProject || die
}

src_prepare() {
	default

	# Let's make the autorevision work.
	echo "m4_define([SVN_REV], ${REV})" > revision.m4
	echo "m4_define([SVN_DATE], ${REV_DATE})" >> revision.m4

	eautoreconf
}

src_configure() {
	# Bug 858338
	append-flags -fno-strict-aliasing

	setup-wxwidgets

	# USE="contrib -fortran" setup:
	use fortran || CONF_WITH_LST=$(use_with contrib contrib-plugins all,-FortranProject)
	# USE="contrib fortran" setup:
	use fortran && CONF_WITH_LST=$(use_with contrib contrib-plugins all)
	# USE="-contrib fortran" setup:
	use contrib || CONF_WITH_LST=$(use_with fortran contrib-plugins FortranProject)

	local myeconfargs=(
		--disable-pch
		--disable-static
		$(use_with contrib boost-libdir "${ESYSROOT}/usr/$(get_libdir)")
		$(use_enable debug)
		${CONF_WITH_LST}
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
