# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multibuild toolchain-funcs virtualx

DESCRIPTION="The Next Generation Spice (Electronic Circuit Simulator)"
SRC_URI="mirror://sourceforge/ngspice/${P}.tar.gz
	doc? ( mirror://sourceforge/ngspice/${P}-manual.pdf )"
HOMEPAGE="http://ngspice.sourceforge.net"
LICENSE="BSD GPL-2"

SLOT="0"
IUSE="X debug deprecated doc examples fftw openmp +readline +shared tcl"
KEYWORDS="~amd64 ~arm64 ~ppc ~riscv ~sparc ~x86 ~x64-macos"

RESTRICT="!test? ( test )"

DEPEND="sys-libs/ncurses:0=
	X? ( x11-libs/libXaw
		x11-libs/libXt
		x11-libs/libX11 )
	fftw? ( sci-libs/fftw:3.0 )
	readline? ( sys-libs/readline:0= )
	tcl? ( dev-lang/tcl:0
		dev-tcltk/blt )"
RDEPEND="${DEPEND}"

DOCS=(
	ANALYSES
	AUTHORS
	BUGS
	ChangeLog
	DEVICES
	FAQ
	NEWS
	README
	README.vdmos
	Stuarts_Poly_Notes
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	MULTIBUILD_VARIANTS=( "binaries" )
	use shared && MULTIBUILD_VARIANTS+=( "shared" )
	use tcl && MULTIBUILD_VARIANTS+=( "tcl" )
}

src_prepare() {
	default

	if use tcl; then
		if use examples; then
			find examples/tclspice -type f -iname \*tcl -or -iname \*.sh |
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
	multibuild_copy_sources
}

src_configure() {
	multibuild_foreach_variant ngspice_configure
}

ngspice_configure() {
	local myeconfargs

	pushd "${BUILD_DIR}" &>/dev/null || die

	if use debug; then
		myeconfargs=(
			--enable-debug
			--enable-ftedebug
			--enable-cpdebug
			--enable-sensdebug
			--enable-asdebug
			--enable-stepdebug
			--enable-pzdebug
		)
	else
		myeconfargs=(
			--disable-debug
			--disable-ftedebug
			--disable-cpdebug
			--disable-sensdebug
			--disable-asdebug
			--disable-stepdebug
			--disable-pzdebug
		)
	fi

	# As of March 2021, these do not compile
	myeconfargs+=(
		--disable-blktmsdebug
		--disable-smltmsdebug
	)

	myeconfargs+=(
		--enable-xspice
		--enable-cider
		--disable-rpath
		$(use_enable openmp)
		$(use_with fftw fftw3)
		$(use_with readline)
	)

	if [[ "${MULTIBUILD_VARIANT}" == "shared" ]]; then
		myeconfargs+=( --with-ngshared )
	elif [[ "${MULTIBUILD_VARIANT}" == "tcl" ]]; then
		myeconfargs+=( --with-tcl="${EPREFIX}/usr/$(get_libdir)" )
	else
		myeconfargs+=(
			$(use_enable deprecated oldapps)
			$(use_with X x)
		)
	fi

	econf "${myeconfargs[@]}"

	popd &>/dev/null || die
}

src_compile() {
	multibuild_foreach_variant ngspice_compile
}

ngspice_compile() {
	pushd "${BUILD_DIR}" &>/dev/null || die
	default
	popd &>/dev/null || die
}

src_install() {
	multibuild_foreach_variant ngspice_install

	# merge the installations of all variants
	local v
	for v in "${MULTIBUILD_VARIANTS[@]}" ; do
		cp -a "${ED}/tmp/${v}"/* "${ED}" || die "Failed to combine multibuild installations"
	done
	rm -rf "${ED}/tmp" || die

	use tcl && DOCS+=( README.tcl )
	use shared && DOCS+=( README.shared-xspice )
	use doc && DOCS+=( "${DISTDIR}"/${P}-manual.pdf )

	default

	if use examples; then
		if ! use tcl; then
			rm -rf examples/tclspice || die
		fi

		insinto /usr/share/${PN}
		doins -r examples
	fi
}

ngspice_install() {
	pushd "${BUILD_DIR}" &>/dev/null || die

	emake DESTDIR="${ED}/tmp/${MULTIBUILD_VARIANT}" install

	# Strip shared-library and Tcl-module builds to the bare minimum;
	# all the support files will have been handled by the 'binaries' build.
	if [[ "${MULTIBUILD_VARIANT}" != "binaries" ]]; then
		rm -rf "${ED}/tmp/${MULTIBUILD_VARIANT}"/usr/bin{,.debug} || die
		rm -rf "${ED}/tmp/${MULTIBUILD_VARIANT}"/usr/share || die
		rm -rf "${ED}/tmp/${MULTIBUILD_VARIANT}"/usr/$(get_libdir)/*.la || die
		rm -rf "${ED}/tmp/${MULTIBUILD_VARIANT}"/usr/$(get_libdir)/ngspice/*.cm{,.debug} || die
	fi

	popd &>/dev/null || die
}

src_test() {
	if ! use debug; then
		# tests can be only executed for the binaries variant
		pushd "${WORKDIR}/${P}-binaries" &>/dev/null || die
		echo "set ngbehavior=mc" > "${HOME}"/.spiceinit || die "Failed to configure ${PN} for running the test suite"
		virtx default
		popd &>/dev/null || die
	else
		# https://sourceforge.net/p/ngspice/bugs/353/
		ewarn
		ewarn "Skipping tests because they are known to fail in debug mode"
		ewarn
	fi
}
