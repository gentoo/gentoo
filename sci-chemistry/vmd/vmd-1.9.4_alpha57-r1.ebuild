# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit cuda desktop prefix python-single-r1 toolchain-funcs xdg

DESCRIPTION="Visual Molecular Dynamics"
HOMEPAGE="http://www.ks.uiuc.edu/Research/vmd/"

MY_PV="${PV/_alpha/a}"
MY_P="${PN}-${MY_PV}"
SRC_URI="
	${MY_P}.src.tar.gz
	fetch+https://dev.gentoo.org/~pacho/${PN}/${PN}-1.9.4_alpha57-gentoo-patches.tar.xz
"
S="${WORKDIR}/${MY_P}"
LICENSE="vmd"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="cuda gromacs msms povray sqlite tachyon xinerama"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="fetch"

CDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/numpy-2[${PYTHON_USEDEP}]
	')
	>=dev-lang/tk-8.6.1:0=
	dev-lang/perl
	dev-libs/expat
	sci-libs/netcdf:0=
	virtual/opengl
	>=x11-libs/fltk-1.1.10-r2:1
	x11-libs/libXft
	x11-libs/libXi
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4.2.9-r1:= )
	gromacs? ( >=sci-chemistry/gromacs-5.0.4-r1:0=[tng] )
	sqlite? ( dev-db/sqlite:3= )
	tachyon? ( >=media-gfx/tachyon-0.99_beta6 )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${CDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-lang/swig
"
RDEPEND="${CDEPEND}
	sci-biology/stride
	sci-chemistry/chemical-mime-data
	sci-chemistry/surf
	x11-misc/xdg-utils
	x11-terms/xterm
	msms? ( sci-chemistry/msms-bin )
	povray? ( media-gfx/povray )
"
VMD_DOWNLOAD="http://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD"

# Binary only plugin
QA_PREBUILT="usr/lib*/vmd/plugins/LINUX/tcl/intersurf/bin/intersurf.so"
QA_FLAGS_IGNORED_amd64=" usr/lib64/vmd/plugins/LINUX/tcl/volutil/volutil"
QA_FLAGS_IGNORED_x86=" usr/lib/vmd/plugins/LINUX/tcl/volutil/volutil"

pkg_nofetch() {
	elog "Please download ${MY_P}.src.tar.gz from"
	elog "${VMD_DOWNLOAD}"
	elog "after agreeing to the license."
	elog "Place it into your DISTDIR directory."
}

src_prepare() {
	# Apply user patches from ${WORKDIR} to allow patching on patches
	# subdir too
	cd "${WORKDIR}"
	default

	# https://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/32121.html
	# https://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/32116.html
	eapply "${WORKDIR}"/${PN}-patches/${PN}-1.9.4a51-gentoo-plugins.patch

	use cuda && cuda_sanitize

	# Prepare plugins
	cd plugins || die

	sed '/^.SILENT/d' -i $(find -name Makefile)

	sed \
		-e "s:CC = gcc:CC = $(tc-getCC):" \
		-e "s:CXX = g++:CXX = $(tc-getCXX):" \
		-e "s:COPTO =.*\":COPTO = -fPIC -o \":" \
		-e "s:LOPTO = .*\":LOPTO = ${LDFLAGS} -fPIC -o \":" \
		-e "s:CCFLAGS =.*\":CCFLAGS = ${CFLAGS}\":" \
		-e "s:CXXFLAGS =.*\":CXXFLAGS = ${CXXFLAGS}\":" \
		-e "s:SHLD = gcc:SHLD = $(tc-getCC):" \
		-e "s:SHXXLD = g++:SHXXLD = $(tc-getCXX):" \
		-e "s:-ltcl8.5:-ltcl:" \
		-i Make-arch || die "Failed to set up plugins Makefile"

	sed \
		-e '/^AR /s:=:?=:g' \
		-e '/^RANLIB /s:=:?=:g' \
		-i ../plugins/*/Makefile || die

	tc-export AR RANLIB

	sed \
		-e "s:\$(CXXFLAGS)::g" \
		-i hesstrans/Makefile || die

	# prepare vmd itself
	cd "${S}" || die

	eapply "${WORKDIR}"/${PN}-patches/${PN}-1.9.4a51-gentoo-paths.patch

	# https://www.ks.uiuc.edu/Research/vmd/mailing_list/vmd-l/32122.html
	eapply "${WORKDIR}"/${PN}-patches/${PN}-1.9.4-tmpdir.patch

	# PREFIX
	sed \
		-e "s:/usr/include/:${EPREFIX}/usr/include:g" \
		-i configure || die

	sed \
		-e "s:gentoo-bindir:${ED}/usr/bin:g" \
		-e "s:gentoo-libdir:${ED}/usr/$(get_libdir):g" \
		-e "s:gentoo-opengl-include:${EPREFIX}/usr/include/GL:g" \
		-e "s:gentoo-opengl-libs:${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:gentoo-gcc:$(tc-getCC):g" \
		-e "s:gentoo-g++:$(tc-getCXX):g" \
		-e "s:gentoo-nvcc:${EPREFIX}/opt/cuda/bin/nvcc:g" \
		-e "s:gentoo-cflags:${CFLAGS}:g" \
		-e "s:gentoo-cxxflags:${CXXFLAGS}:g" \
		-e "s:gentoo-nvflags::g" \
		-e "s:gentoo-ldflags:${LDFLAGS}:g" \
		-e "s:gentoo-plugindir:${WORKDIR}/plugins:g" \
		-e "s:gentoo-fltk-include:$(fltk-config --includedir):g" \
		-e "s:gentoo-fltk-libs:$(dirname $(fltk-config --libs)) -Wl,-rpath,$(dirname $(fltk-config --libs)):g" \
		-e "s:gentoo-libtachyon-include:${EPREFIX}/usr/include/tachyon:g" \
		-e "s:gentoo-libtachyon-libs:${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:gentoo-netcdf-include:${EPREFIX}/usr/include:g" \
		-e "s:gentoo-netcdf-libs:${EPREFIX}/usr/$(get_libdir):g" \
		-i configure || die

	if use cuda; then
		sed \
			-e "s:gentoo-cuda-lib:${EPREFIX}/opt/cuda/$(get_libdir):g" \
			-e "/NVCCFLAGS/s:=:= ${NVCCFLAGS}:g" \
			-i configure src/Makefile || die
		sed \
			-e '/compute_/d' \
			-i configure || die
		sed \
			-e 's:-gencode .*code=sm_..::' \
			-i src/Makefile || die
	fi

	sed \
		-e "s:LINUXPPC:LINUX:g" \
		-e "s:LINUXALPHA:LINUX:g" \
		-e "s:LINUXAMD64:LINUX:g" \
		-e "s:gentoo-stride:${EPREFIX}/usr/bin/stride:g" \
		-e "s:gentoo-surf:${EPREFIX}/usr/bin/surf:g" \
		-e "s:gentoo-tachyon:${EPREFIX}/usr/bin/tachyon:g" \
		-i "${S}"/bin/vmd.sh || die "failed setting up vmd wrapper script"

	EMAKEOPTS=(
		TCLINC="-I${EPREFIX}/usr/include"
		TCLLIB="-L${EPREFIX}/usr/$(get_libdir)"
		NETCDFLIB="$($(tc-getPKG_CONFIG) --libs-only-L netcdf)${EPREFIX}/usr/$(get_libdir)/libnetcdf.so"
		NETCDFINC="$($(tc-getPKG_CONFIG) --cflags-only-I netcdf)${EPREFIX}/usr/include"
		NETCDFLDFLAGS="$($(tc-getPKG_CONFIG) --libs netcdf)"
		NETCDFDYNAMIC=1
		EXPATINC="-I${EPREFIX}/usr/include"
		EXPATLIB="$($(tc-getPKG_CONFIG) --libs expat)"
		EXPATDYNAMIC=1
	)
	if use gromacs; then
		EMAKEOPTS+=(
			TNGLIB="$($(tc-getPKG_CONFIG) --libs libgromacs)"
			TNGINC="-I${EPREFIX}/usr/include"
			TNGDYNAMIC=1
		)
	fi
	if use sqlite; then
		EMAKEOPTS+=(
			SQLITELIB="$($(tc-getPKG_CONFIG) --libs sqlite3)"
			SQLITEINC="-I${EPREFIX}/usr/include"
			SQLITEDYNAMIC=1
		)
	fi
}

src_configure() {
	local myconf="OPENGL OPENGLPBUFFER COLVARS FLTK TK TCL PTHREADS PYTHON IMD NETCDF NUMPY NOSILENT XINPUT"
	rm -f configure.options && echo $myconf >> configure.options

	use cuda && myconf+=" CUDA"
#	use mpi && myconf+=" MPI"
	use tachyon && myconf+=" LIBTACHYON"
	use xinerama && myconf+=" XINERAMA"

	export \
		PYTHON_INCLUDE_DIR="$(python_get_includedir)" \
		PYTHON_LIBRARY_DIR="$(python_get_library_path)" \
		PYTHON_LIBRARY="$(python_get_LIBS)" \
		NUMPY_INCLUDE_DIR="$(python_get_sitedir)/numpy/_core/include" \
		NUMPY_LIBRARY_DIR="$(python_get_sitedir)/numpy/_core/include"

	perl ./configure LINUX \
		${myconf} || die
}

src_compile() {
	# build plugins
	cd "${WORKDIR}"/plugins || die

	emake \
		${EMAKEOPTS[@]} \
		LINUX

	# build vmd
	cd "${S}"/src || die
	emake
}

src_install() {
	# install plugins
	cd "${WORKDIR}"/plugins || die
	emake \
			PLUGINDIR="${ED}/usr/$(get_libdir)/${PN}/plugins" \
			distrib

	# install vmd
	cd "${S}"/src || die
	emake install

	# install docs
	cd "${S}" || die
	dodoc Announcement README doc/ig.pdf doc/ug.pdf

	# remove some of the things we don't want and need in
	# /usr/lib
	cd "${ED}"/usr/$(get_libdir)/vmd || die
	rm -fr doc README Announcement LICENSE || \
		die "failed to clean up /usr/lib/vmd directory"

	# adjust path in vmd wrapper
	sed \
		-e "s:${ED}::" -i "${ED}"/usr/bin/${PN} \
		-e "/^defaultvmddir/s:^.*$:defaultvmddir=\"${EPREFIX}/usr/$(get_libdir)/${PN}\":g" \
		|| die "failed to set up vmd wrapper script"

	# install icon and generate desktop entry
	insinto /usr/share/pixmaps
	doins "${WORKDIR}"/vmd-patches/vmd.png
	eprefixify "${WORKDIR}"/vmd-patches/vmd.desktop
	domenu "${WORKDIR}"/vmd-patches/vmd.desktop
}
