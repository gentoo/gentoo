# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 cmake-utils

DESCRIPTION="Powerful map generator"
HOMEPAGE="https://gmt.soest.hawaii.edu/"
SRC_URI="mirror://gmt/${P}-src.tar.xz"

LICENSE="GPL-3+ gmttria? ( Artistic )"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="+dcw doc examples +fftw +gdal gmttria +gshhg htmldoc lapack openmp pcre pcre2 threads tutorial"

RDEPEND="
	!sci-biology/probcons
	app-text/ghostscript-gpl
	dcw? ( sci-geosciences/dcw-gmt )
	fftw? ( sci-libs/fftw:3.0/3 )
	gdal? ( sci-libs/gdal )
	gshhg? ( sci-geosciences/gshhg-gmt )
	>=sci-libs/netcdf-4.1[hdf5]
	lapack? ( virtual/lapack )
	pcre? ( dev-libs/libpcre )
	pcre2? ( dev-libs/libpcre2 )
	net-misc/curl
	sys-libs/zlib"

DEPEND="${RDEPEND}"

REQUIRED_USE="?? ( pcre pcre2 )"

src_prepare() {
	cmake-utils_src_prepare
	# Rename man pages to avoid a name conflict with gmt4
	pushd man_release || die
	local m c suffix newc
	for m in *.gz; do
		c=${m%%.*}
		suffix=${m#*.}
		newc=gmt_${c}
		# This man pages does'nt conflict
		case "${c}" in
		"gmt" | "gmt.conf" | "postscriptlight")
			continue ;;
		"gmt_shell_functions")
			newc=gmt5_shell_functions ;;
		"gmtcolors")
			newc=gmt5colors ;;
		esac
		mv "${c}.${suffix}" "${newc}.${suffix}" || die
	done
	popd || die
}

src_configure() {
	local mycmakeargs=(
		-DLICENSE_RESTRICTED="$(usex gmttria no yes)"
		-DGMT_OPENMP="$(usex openmp)"
		-DGMT_USE_THREADS="$(usex threads)"
		-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES=OFF # Install bash completions properly
		-DGMT_INSTALL_MODULE_LINKS=OFF # Don't install symlinks on gmt binary, they are conflicted with gmt4
		-DBASH_COMPLETION_DIR="$(get_bashcompdir)"
		-DGMT_DATADIR="share/${P}"
		-DGMT_DOCDIR="share/doc/${PF}"
		-DGMT_MANDIR="share/man"
	)
	use fftw || mycmakeargs+=( -DGMT_EXCLUDE_FFTW3=yes )
	use gdal || mycmakeargs+=( -DGMT_EXCLUDE_GDAL=yes )
	use lapack || mycmakeargs+=( -DGMT_EXCLUDE_LAPACK=yes )
	use pcre || mycmakeargs+=( -DGMT_EXCLUDE_PCRE=yes )
	use pcre2 || mycmakeargs+=( -DGMT_EXCLUDE_PCRE2=yes )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# Remove various documentation
	if ! use doc; then
		rm -rf "${ED}/usr/share/doc/${PF}/pdf" || die
	fi

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
	else
		rm -rf "${ED}/usr/share/doc/${PF}/examples" || die
	fi

	if ! use htmldoc; then
		rm -rf "${ED}/usr/share/doc/${PF}/html" || die
	fi

	if use tutorial; then
		docompress -x /usr/share/doc/${PF}/tutorial
	else
		rm -rf "${ED}/usr/share/doc/${PF}/tutorial" || die
	fi

	# Decompress manuals
	find "${ED}/usr/share/man" -name "*.gz" -exec gunzip {} + || die
	# Rename some files to avoid a name conflict with gmt4
	mv "${ED}/usr/bin/gmt_shell_functions.sh" "${ED}/usr/bin/gmt5_shell_functions.sh" || die
	mv "${ED}/usr/bin/isogmt" "${ED}/usr/bin/isogmt5" || die
	rm "${ED}/usr/bin/gmtswitch" || die
	# Rename bash completion file
	mv "${D}$(get_bashcompdir)/gmt_completion.bash" "${D}$(get_bashcompdir)/gmt" || die
}
