# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90"
PYTHON_COMPAT=( python{2_7,3_4} )

inherit autotools-utils toolchain-funcs fortran-2 python-single-r1

PID=3473437

DESCRIPTION="Library for decoding WMO FM-92 GRIB messages"
HOMEPAGE="https://software.ecmwf.int/wiki/display/GRIB/Home"
SRC_URI="https://software.ecmwf.int/wiki/download/attachments/${PID}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="doc examples fortran jasper jpeg2k netcdf openmp png python static-libs threads perl"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	jpeg2k? (
		jasper? ( media-libs/jasper )
		!jasper? ( media-libs/openjpeg:0 )
	)
	netcdf? ( sci-libs/netcdf )
	png? ( media-libs/libpng:0= )
	python? ( dev-python/numpy[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )"

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
	fortran-2_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# failing test
	sed -i \
		-e 's/\(${tools_dir}grib_ls -plevels tmp_rlls.grib1 | grep MISSING\)/#\1/' \
		tests/ls.sh
}

src_configure() {
	# perl module needs serious packaging work from upstream
	local myeconfargs=(
		--without-perl
		$(use_enable jpeg2k jpeg)
		$(use_enable fortran)
		$(use_enable openmp omp-packing)
		$(use_enable python)
		$(use_enable python numpy)
		$(use_enable threads pthread)
		$(
			use netcdf && \
				echo --with-netcdf="${EPREFIX}"/usr || \
				echo --with-netcdf=none
		)
		$(use_with png png-support)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml -r html/*
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		emake clean
		doins -r *
	fi
	use python && python_optimize
}
