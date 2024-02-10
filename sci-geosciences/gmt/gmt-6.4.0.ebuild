# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 cmake

DESCRIPTION="Powerful map generator"
HOMEPAGE="https://www.generic-mapping-tools.org"
SRC_URI="https://github.com/GenericMappingTools/${PN}/releases/download/${PV}/${P}-src.tar.xz"

LICENSE="GPL-3+ gmttria? ( Artistic )"
SLOT="6"
KEYWORDS="amd64 ~x86"
IUSE="blas +fftw ffmpeg +gdal geos gmttria lapack openmp pcre threads zlib"

DEPEND="
	app-text/ghostscript-gpl:=
	media-gfx/graphicsmagick:=
	net-misc/curl
	>=sci-libs/netcdf-4.1:=[hdf5]
	media-video/ffmpeg:=
	blas? ( virtual/blas )
	fftw? ( sci-libs/fftw:3.0= )
	gdal? ( sci-libs/gdal:= )
	geos? ( sci-libs/geos )
	lapack? ( virtual/lapack )
	pcre? ( dev-libs/libpcre2 )
	zlib? ( sys-libs/zlib:= )
"
RDEPEND="${DEPEND}
	!sci-biology/probcons
	sci-geosciences/dcw-gmt
	sci-geosciences/gshhg-gmt
"

src_prepare() {
	cmake_src_prepare
	# Rename man pages to avoid a name conflict with gmt5
	pushd man_release || die
	local m c suffix newc
		for m in *.gz; do
			c=${m%%.*}
			suffix=${m#*.}
			if [[ "${c}" == "gmt"  ]]; then
				newc=gmt${SLOT}
			else
				newc=gmt${SLOT}_${c}
			fi
			mv "${c}.${suffix}" "${newc}.${suffix}" || die
		done
	popd || die
}

src_configure() {
	local mycmakeargs=(
		-DGMT_DATADIR="share/${P}"
		-DGMT_DOCDIR="share/doc/${PF}"
		-DGMT_MANDIR="share/man"
		-DLICENSE_RESTRICTED=$(usex gmttria no yes)
		-DGMT_ENABLE_OPENMP=$(usex openmp)
		-DGMT_USE_THREADS=$(usex threads)
		-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES=OFF # Install bash completions properly
		-DGMT_INSTALL_MODULE_LINKS=OFF # Don't install symlinks on gmt binary, they are conflicted with gmt5
		-DGMT_INSTALL_NAME_SUFFIX="${SLOT}"
		-DBASH_COMPLETION_DIR="$(get_bashcompdir)"
		-DCMAKE_DISABLE_FIND_PACKAGE_PCRE=ON
		$(cmake_use_find_package blas BLAS)
		$(cmake_use_find_package gdal GDAL)
		$(cmake_use_find_package geos GEOS)
		$(cmake_use_find_package fftw FFTW3)
		$(cmake_use_find_package lapack LAPACK)
		$(cmake_use_find_package pcre PCRE2)
		$(cmake_use_find_package zlib ZLIB)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	docompress -x /usr/share/doc/${PF}/examples
	docompress -x /usr/share/doc/${PF}/tutorial

	# remove conflicting symlink
	rm "${ED}/usr/bin/gmt" || die
	rm "${ED}/usr/$(get_libdir)/libgmt.so" || die
	rm "${ED}/usr/$(get_libdir)/libpostscriptlight.so" || die

	# Decompress manuals
	find "${ED}/usr/share/man" -name "*.gz" -exec gunzip {} + || die
	# Rename bash completion file
	mv "${D}$(get_bashcompdir)/gmt_completion.bash" "${D}$(get_bashcompdir)/gmt${SLOT}" || die
}
