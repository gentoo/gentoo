# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cmake flag-o-matic

DESCRIPTION="Powerful map generator"
HOMEPAGE="https://gmt.soest.hawaii.edu/"
SRC_URI="mirror://gmt/${P}-src.tar.xz"

LICENSE="GPL-3+ gmttria? ( Artistic )"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE="doc examples +fftw +gdal gmttria htmldoc lapack openmp pcre pcre2 threads tutorial"

REQUIRED_USE="?? ( pcre pcre2 )"

DEPEND="
	app-text/ghostscript-gpl
	net-misc/curl
	>=sci-libs/netcdf-4.1:=[hdf5]
	sys-libs/zlib
	fftw? ( sci-libs/fftw:3.0= )
	gdal? ( sci-libs/gdal:= )
	lapack? ( virtual/lapack )
	pcre? ( dev-libs/libpcre )
	pcre2? ( dev-libs/libpcre2 )
"
RDEPEND="${DEPEND}
	!sci-biology/probcons
	sci-geosciences/dcw-gmt
	sci-geosciences/gshhg-gmt
"

PATCHES=( "${FILESDIR}"/${P}-sighandler.patch )

src_prepare() {
	cmake_src_prepare
	# Rename man pages to avoid a name conflict with gmt4
	pushd man_release || die
	local m c suffix newc
		for m in *.gz; do
			c=${m%%.*}
			suffix=${m#*.}
			newc=gmt_${c}
			# This man pages does'nt conflict
			case ${c} in
				gmt|gmt.conf|postscriptlight)
					continue ;;
				gmt_shell_functions)
					newc=gmt5_shell_functions ;;
				gmtcolors)
					newc=gmt5colors ;;
			esac
			mv "${c}.${suffix}" "${newc}.${suffix}" || die
		done
	popd || die
}

src_configure() {
	# https://bugs.gentoo.org/710088
	# drop on version bump
	append-cflags -fcommon
	local mycmakeargs=(
		-DGMT_DATADIR="share/${P}"
		-DGMT_DOCDIR="share/doc/${PF}"
		-DGMT_MANDIR="share/man"
		-DLICENSE_RESTRICTED=$(usex gmttria no yes)
		-DGMT_OPENMP=$(usex openmp)
		-DGMT_USE_THREADS=$(usex threads)
		-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES=OFF # Install bash completions properly
		-DGMT_INSTALL_MODULE_LINKS=OFF # Don't install symlinks on gmt binary, they are conflicted with gmt4
		-DBASH_COMPLETION_DIR="$(get_bashcompdir)"
		$(cmake_use_find_package gdal GDAL)
		$(cmake_use_find_package fftw FFTW3)
		$(cmake_use_find_package lapack LAPACK)
		$(cmake_use_find_package pcre PCRE)
	)
	use pcre || mycmakeargs+=( $(cmake_use_find_package pcre2 PCRE2) )

	cmake_src_configure
}

src_install() {
	cmake_src_install
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
