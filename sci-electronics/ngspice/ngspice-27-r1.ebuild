# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multibuild toolchain-funcs

DESCRIPTION="The Next Generation Spice (Electronic Circuit Simulator)"
SRC_URI="mirror://sourceforge/ngspice/${P}.tar.gz
	doc? ( mirror://sourceforge/ngspice/${P}-manual.pdf )"
HOMEPAGE="http://ngspice.sourceforge.net"
LICENSE="BSD GPL-2"

SLOT="0"
IUSE="X debug doc examples fftw openmp readline +shared tcl"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x64-macos"

DEPEND="sys-libs/ncurses:0=
	X? ( x11-libs/libXaw
		x11-libs/libXt
		x11-libs/libX11 )
	fftw? ( sci-libs/fftw:3.0 )
	readline? ( sys-libs/readline:0= )
	tcl? ( dev-lang/tcl:0
		dev-tcltk/blt )"
RDEPEND="${DEPEND}
	X? ( sci-visualization/xgraph )"

DOCS=(
	ANALYSES
	AUTHORS
	BUGS
	ChangeLog
	DEVICES
	NEWS
	README
	Stuarts_Poly_Notes
)

PATCHES=(
	"${FILESDIR}"/${P}-autoconf_fftw3.patch
	"${FILESDIR}"/${P}-blt_linkage_workaround.patch
	"${FILESDIR}"/${P}-fix_parsing_tcl_commands.patch
	"${FILESDIR}"/${P}-split_terminfo.patch
)

pkg_setup() {
	MULTIBUILD_VARIANTS=( "binaries" )
	use shared && MULTIBUILD_VARIANTS+=( "shared" )
	use tcl && MULTIBUILD_VARIANTS+=( "tcl" )
	use openmp && tc-check-openmp
}

src_prepare() {
	default

	if use tcl; then
		if use examples; then
			find examples/tclspice -type f -iname \*tcl |
			while read s
			do
				sed -i -e 's@../../../src/.libs/libspice.so@libspice.so@g' \
					-e 's@package require BLT@package require Tk\npackage require BLT@g' \
					-e "s@spice::codemodel \(.*\)/\(.*\).cm@spice::codemodel /usr/$(get_libdir)/ngspice/\2.cm@g" \
					"${s}" || die "sed failed"
			done
		fi
	fi

	eautoreconf
}

src_configure() {
	multibuild_copy_sources
	multibuild_foreach_variant ngspice_configure
}

ngspice_configure() {
	pushd "${BUILD_DIR}"

	local myconf
	if use debug; then
		myconf="--enable-debug \
			--enable-ftedebug \
			--enable-cpdebug \
			--enable-sensdebug \
			--enable-asdebug \
			--enable-stepdebug \
			--enable-pzdebug"
	else
		myconf="--disable-debug \
			--disable-ftedebug \
			--disable-cpdebug \
			--disable-sensdebug \
			--disable-asdebug \
			--disable-stepdebug \
			--disable-pzdebug"
	fi
	# As of December 2017, these do not compile
	myconf="${myconf} \
		--disable-blktmsdebug \
		--disable-smltmsdebug"

	myconf="${myconf} \
		--enable-xspice \
		--enable-cider \
		--disable-xgraph \
		--disable-dependency-tracking \
		--disable-rpath \
		$(use_enable openmp) \
		$(use_with fftw fftw3) \
		$(use_with readline)"

	if [ "${MULTIBUILD_VARIANT}" == "shared" ]; then
		myconf="${myconf} \
			--with-ngshared"
	elif [ "${MULTIBUILD_VARIANT}" == "tcl" ]; then
		myconf="${myconf} \
			--with-tcl"
	else
		myconf="${myconf} \
			$(use_with X x)"
	fi

	econf ${myconf}
}

src_compile() {
	multibuild_foreach_variant ngspice_compile
}

ngspice_compile() {
	pushd "${BUILD_DIR}"
	default
}

src_install() {
	multibuild_foreach_variant ngspice_install

	# merge the installations of all variants
	for v in "${MULTIBUILD_VARIANTS[@]}" ; do
		cp -a "${D}_${v}"/* "${D}" || die "Failed to combine multibuild installations"
		rm -rf "${D}_${v}"
	done

	use tcl && DOCS+=( README.tcl )
	use doc && DOCS+=( "${DISTDIR}"/${P}-manual.pdf )

	default

	# We don't need ngmakeidx to be installed
	rm -f "${D}"/usr/bin/ngmakeidx
	rm -f "${D}"/usr/share/man/man1/ngmakeidx.1

	if use examples; then
		use tcl || rm -rf examples/tclspice

		insinto /usr/share/${PN}
		doins -r examples
	fi
}

ngspice_install() {
	pushd "${BUILD_DIR}"

	emake DESTDIR="${D}_${MULTIBUILD_VARIANT}" install

	# Strip shared-library and Tcl-module builds to the bare minimum;
	# all the support files will have been handled by the 'binaries' build.
	if [ "${MULTIBUILD_VARIANT}" != "binaries" ]; then
		rm -rf "${D}_${MULTIBUILD_VARIANT}"/usr/bin{,.debug}
		rm -rf "${D}_${MULTIBUILD_VARIANT}"/usr/share
		rm -rf "${D}_${MULTIBUILD_VARIANT}"/usr/$(get_libdir)/*.la
		rm -rf "${D}_${MULTIBUILD_VARIANT}"/usr/$(get_libdir)/ngspice/*.cm{,.debug}
	fi
}

src_test() {
	if ! use debug; then
		multibuild_foreach_variant ngspice_test
	else
		# https://sourceforge.net/p/ngspice/bugs/353/
		ewarn
		ewarn "Skipping tests because they are known to fail in debug mode"
		ewarn
	fi
}

ngspice_test() {
	pushd "${BUILD_DIR}"
	default
}
