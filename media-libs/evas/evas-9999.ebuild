# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/evas/evas-9999.ebuild,v 1.2 2015/01/29 17:30:44 mgorny Exp $

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="hardware-accelerated retained canvas API"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Evas"

LICENSE="BSD-2"
IUSE="altivec bidi +bmp directfb +eet fbcon +fontconfig gles gif +ico +jpeg cpu_flags_x86_mmx opengl +png +ppm +psd cpu_flags_x86_sse cpu_flags_x86_sse3 static-libs tga tiff wayland X xcb xpm"

RDEPEND=">=dev-libs/eina-${PV}
	>=media-libs/freetype-2.3.9
	fontconfig? ( media-libs/fontconfig )
	gles? ( media-libs/mesa[gallium,gles2] )
	gif? ( media-libs/giflib )
	jpeg? ( virtual/jpeg )
	png? ( media-libs/libpng:0= )
	bidi? ( >=dev-libs/fribidi-0.19.1 )
	directfb? ( >=dev-libs/DirectFB-0.9.16 )
	tiff? ( media-libs/tiff )
	wayland? ( dev-libs/wayland )
	xpm? ( x11-libs/libXpm )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrender
		opengl? ( virtual/opengl )
	)
	!X? (
		xcb? (
			x11-libs/xcb-util
		) )
	eet? ( >=dev-libs/eet-${PV} )"
DEPEND="${RDEPEND}"

src_configure() {
	if use X ; then
		if use xcb ; then
			ewarn "You have enabled both 'X' and 'xcb', so we will use"
			ewarn "X as it's considered the most stable for evas"
		fi
		E_ECONF+=(
			--disable-software-xcb
			$(use_enable opengl gl-xlib)
		)
	elif use xcb ; then
		E_ECONF+=(
			--disable-gl-xlib
			--enable-software-xcb
			$(use_enable opengl gl-xcb)
		)
	else
		E_ECONF+=(
			--disable-gl-xlib
			--disable-software-xcb
			--disable-gl-xcb
		)
	fi
	if use wayland ; then
		E_ECONF+=(
			--enable-wayland-shm
		)
		if use gles ; then
			E_ECONF+=(
				--enable-wayland-egl
			)
		else
			E_ECONF+=(
				--disable-wayland-egl
			)
		fi
	else
		E_ECONF+=(
			--disable-wayland-egl
			--disable-wayland-shm
		)
	fi

	E_ECONF+=(
		$(use_enable altivec cpu-altivec)
		$(use_enable bidi fribidi)
		$(use_enable bmp image-loader-bmp)
		$(use_enable bmp image-loader-wbmp)
		$(use_enable directfb)
		$(use_enable doc)
		$(use_enable eet font-loader-eet)
		$(use_enable eet image-loader-eet)
		$(use_enable fbcon fb)
		$(use_enable fontconfig)
		$(use_enable gles gl-flavor-gles)
		$(use_enable gles gles-variety-sgx)
		$(use_enable gif image-loader-gif)
		$(use_enable ico image-loader-ico)
		$(use_enable jpeg image-loader-jpeg)
		$(use_enable cpu_flags_x86_mmx cpu-mmx)
		$(use_enable png image-loader-png)
		$(use_enable ppm image-loader-pmaps)
		$(use_enable psd image-loader-psd)
		$(use_enable cpu_flags_x86_sse cpu-sse)
		$(use_enable cpu_flags_x86_sse3 cpu-sse3)
		--disable-image-loader-svg
		$(use_enable tga image-loader-tga)
		$(use_enable tiff image-loader-tiff)
		--enable-pthreads
		--enable-async-events
		--enable-async-preload
		$(use_enable X software-xlib)
		$(use_enable xpm image-loader-xpm)
		--enable-evas-magic-debug
		--enable-static-software-generic
		--enable-buffer
		--enable-cpu-c
		--enable-scale-sample
		--enable-scale-smooth
		--enable-convert-8-rgb-332
		--enable-convert-8-rgb-666
		--enable-convert-8-rgb-232
		--enable-convert-8-rgb-222
		--enable-convert-8-rgb-221
		--enable-convert-8-rgb-121
		--enable-convert-8-rgb-111
		--enable-convert-16-rgb-565
		--enable-convert-16-rgb-555
		--enable-convert-16-rgb-444
		--enable-convert-16-rgb-rot-0
		--enable-convert-16-rgb-rot-270
		--enable-convert-16-rgb-rot-90
		--enable-convert-24-rgb-888
		--enable-convert-24-bgr-888
		--enable-convert-32-rgb-8888
		--enable-convert-32-rgbx-8888
		--enable-convert-32-bgr-8888
		--enable-convert-32-bgrx-8888
		--enable-convert-32-rgb-rot-0
		--enable-convert-32-rgb-rot-270
		--enable-convert-32-rgb-rot-90
		--enable-image-loader-generic
		--disable-harfbuzz
		--disable-image-loader-edb
		--disable-static-software-16
		--disable-software-16-x11
	)

	enlightenment_src_configure
}

pkg_postinst() {
	elog "for svg support install media-plugins/evas_generic_loaders[svg]"
}
