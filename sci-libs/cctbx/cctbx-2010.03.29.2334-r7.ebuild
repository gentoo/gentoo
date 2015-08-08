# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils fortran-2 multilib prefix python-single-r1 toolchain-funcs

MY_PV="${PV//./_}"

DESCRIPTION="Computational Crystallography Toolbox"
HOMEPAGE="http://cctbx.sourceforge.net/"
SRC_URI="http://cci.lbl.gov/cctbx_build/results/${MY_PV}/${PN}_bundle.tar.gz -> ${P}.tar.gz"

LICENSE="cctbx-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="+minimal openmp threads"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	?? ( openmp threads )"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	sci-libs/clipper
	sci-libs/fftw:3.0=
	!minimal? (
		sci-chemistry/cns
		sci-chemistry/shelx )"
DEPEND="${RDEPEND}
	!prefix? ( >=dev-util/scons-1.2[${PYTHON_USEDEP}] )"

S="${WORKDIR}"
MY_S="${WORKDIR}"/cctbx_sources
MY_B="${WORKDIR}"/cctbx_build

pkg_setup() {
	use openmp && FORTRAN_NEED_OPENMP="1"
	if use openmp && ! tc-has-openmp; then
		ewarn "You are using gcc and OpenMP is only available with gcc >= 4.2 and icc"
		ewarn "If you want to build ${PN} with OpenMP, abort now,"
		ewarn "and switch CC to an OpenMP capable compiler"
		FORTRAN_NEED_OPENMP=1
	fi
	fortran-2_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	local opts
	local optsld

	epatch \
		"${FILESDIR}"/${PV}-tst_server.py.patch \
		"${FILESDIR}"/${PV}-boost.patch \
		"${FILESDIR}"/${PV}-clipper.patch \
		"${FILESDIR}"/${PV}-flags.patch \
		"${FILESDIR}"/${PV}-soname.patch \
		"${FILESDIR}"/${PV}-gcc-4.6.patch \
		"${FILESDIR}"/${PV}-gcc-4.7.patch \
		"${FILESDIR}"/${PV}-format-security.patch

	eprefixify "${MY_S}"/scitbx/libtbx_refresh.py

	rm -rvf "${MY_S}/boost" "${MY_S}/PyCifRW" >> "${T}"/clean.log || die
	if ! use prefix; then
		rm -rvf "${MY_S}/scons" >> "${T}"/clean.log || die
		echo "import os, sys; os.execvp('scons', sys.argv)" > "${MY_S}"/libtbx/command_line/scons.py || die
	fi

	find "${MY_S}/clipper" -name "*.h" -print -delete >> "${T}"/clean.log || die

	sed \
		-e "/LIBS/s:boost_python:boost_python-$(echo ${EPYTHON} | sed 's/python//'):g" \
		-i "${MY_S}"/boost_adaptbx/SConscript "${MY_S}"/scitbx/boost_python/SConscript || die
}

src_configure() {
	local compiler
	local myconf

	myconf="${MY_S}/libtbx/configure.py"

	compiler=$(expr match "$(tc-getCC)" '.*\([a-z]cc\)')
	myconf="${myconf} --compiler=${compiler}"

	# Additional USE flag usage
	myconf="${myconf} --enable-openmp-if-possible=$(usex openmp true false)"

	use threads && USEthreads="--enable-boost-threads"

	myconf="${myconf} ${USE_threads} --scan-boost --use_environment_flags"

	mkdir "${MY_B}" && myconf="${myconf} --current_working_directory=${MY_B}"
	cd "${MY_B}"

	myconf="${myconf} --build=release fftw3tbx rstbx smtbx mmtbx clipper_adaptbx fable"
	einfo "configuring with ${python} ${myconf}"

	${EPYTHON} ${myconf} || die "configure failed"
}

src_compile() {
	local makeopts_exp

	cd "${MY_B}"

	makeopts_exp=${MAKEOPTS/j/j }
	makeopts_exp=${makeopts_exp%-l[0-9]*}

	source setpaths_all.sh

	einfo "compiling with libtbx.scons ${makeopts_exp}"
	libtbx.scons ${makeopts_exp} .|| die "make failed"
}

src_test(){
	source "${MY_B}"/setpaths_all.sh
	libtbx.python $(libtbx.show_dist_paths boost_adaptbx)/tests/tst_rational.py && \
	libtbx.python ${SCITBX_DIST}/run_tests.py ${MAKEOPTS_EXP} && \
	libtbx.python ${CCTBX_DIST}/run_tests.py  ${MAKEOPTS_EXP} \
	|| die "test failed"
}

src_install(){
	local lib baselib
#	find cctbx_build/ -type f \( -name "*.py" -o -name "*sh" \) -exec \
#	sed -e "s:${MY_S}:${EPREFIX}/usr/$(get_libdir)/cctbx/cctbx_sources:g" \
#	    -e "s:${MY_B}:${EPREFIX}/usr/$(get_libdir)/cctbx/cctbx_build:g"  \
#	    -i '{}' \; || die "Fail to correct path"

	sed \
		-e "s:${MY_B}:${EPREFIX}/usr:g" \
		-e "s:${MY_S}:${EPREFIX}/$(python_get_sitedir):g" \
		-i "${MY_B}/libtbx_env" || die

	insinto /usr/share/cctbx
	doins "${MY_B}/libtbx_env" || die

	ebegin "removing unnessary files"
		rm -r "${S}"/cctbx_sources/{clipper,ccp4io,ucs-fonts,TAG} || die "failed to remove uneeded scons"
		find -O3 "${S}" -type f \
			\( -name "*conftest*" -o -name "*.o" -o -name "*.c" -o -name "*.f" -o -name "*.cpp" -o \
			-name "*.pyc" -o -name "SCons*" -o -name "Makefile" -o -name "config.log" \) -delete \
			-print >> "${T}"/clean.log || die
		find "${S}" -type d -empty -delete -print >> "${T}"/clean.log || die
		find "${MY_B}" -maxdepth 1 -type f -delete -print >> "${T}"/clean.log || die
	eend

	dobin "${MY_B}"/bin/*
	rm -vrf "${MY_B}/bin" >> "${T}"/clean.log || die
	dolib.so "${MY_B}"/lib/lib*
	mv "${ED}"/usr/$(get_libdir)/libscitbx_min{,i}pack.so || die
	rm -vf "${MY_B}"/lib/lib* >> "${T}"/clean.log || die

	for lib in "${ED}"/usr/$(get_libdir)/*.so; do
		baselib=$(basename ${lib})
		mv ${lib}{,.0.0} || die
		dosym ${baselib}.0.0 /usr/$(get_libdir)/${baselib}
	done

	insinto /usr/include
	doins -r "${MY_B}"/include/* || die
	rm -rvf "${MY_B}/include" >> "${T}"/clean.log || die

	insinto /usr/libexec/${PN}
	doins -r "${MY_B}"/* || die
	find "${ED}"/usr/libexec/${PN} -type f -exec chmod 755 '{}' \;

	cd "${MY_S}"
	python_domodule * "${MY_B}"/lib/*
	rm -rvf "${MY_B}/lib" >> "${T}"/clean.log || die

	sed \
		-e "/PYTHONPATH/s:${MY_S}:$(python_get_sitedir):g" \
		-e "/PYTHONPATH/s:${MY_B}:$(python_get_sitedir):g" \
		-e "/LD_LIBRARY_PATH/s:${MY_B}/lib:${EPREFIX}/usr/$(get_libdir):g" \
		-e "/PATH/s:${MY_B}/bin:${EPREFIX}/usr/bin:g" \
		-e "/PATH/s:${MY_B}/exe:${EPREFIX}/usr/bin:g" \
		-e "/exec/s:${MY_S}:$(python_get_sitedir):g" \
		-e "/LIBTBX_BUILD/s:${MY_B}:${EPREFIX}/usr/share/cctbx:g" \
		-e "s:${MY_B}/exe_dev/:${EPREFIX}/usr/libexec/${PN}/exe_dev/:g" \
		-i "${ED}"/usr/bin/* || die

	python_optimize
}
