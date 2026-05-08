# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="sqlite"  # bug 572440

inherit cmake desktop flag-o-matic python-single-r1 toolchain-funcs xdg

DESCRIPTION="Free GIS with raster and vector functionality, as well as 3D vizualization"
HOMEPAGE="https://grass.osgeo.org/"

LICENSE="GPL-2"

if [[ ${PV} == *9999* ]]; then
	SLOT="0/8.5"
else
	SLOT="0/$(ver_cut 1-2 ${PV})"
fi

GVERSION=${SLOT#*/}
MY_PM="${PN}${GVERSION}"
MY_PM="${MY_PM/.}"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OSGeo/grass.git"
else
	MY_P="${P/_rc/RC}"
	SRC_URI="https://github.com/OSGeo/grass/releases/download/${PV}/${P}.tar.gz"
	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64 ~ppc ~x86"
	fi

	S="${WORKDIR}/${MY_P}"
fi

IUSE="blas bzip2 cxx doc fftw geos lfs lapack mysql netcdf nls odbc opencl opengl openmp pdal png postgres readline sqlite svm threads tiff truetype X zstd"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	lapack? ( blas )
	opengl? ( X )
	pdal? ( cxx )"

RDEPEND="
	${PYTHON_DEPS}
	>=app-admin/eselect-1.2
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	')
	sci-libs/gdal:=
	sys-libs/gdbm:=
	sys-libs/ncurses:=
	sci-libs/proj:=
	virtual/zlib:=
	media-libs/libglvnd
	media-libs/glu
	blas? (
		|| (
			virtual/cblas[eselect-ldso(+)]
			virtual/cblas[flexiblas(-)]
		)
		|| (
			virtual/blas[eselect-ldso(+)]
			virtual/blas[flexiblas(-)]
		)
	)
	bzip2? ( app-arch/bzip2:= )
	fftw? ( sci-libs/fftw:3.0= )
	geos? ( sci-libs/geos:= )
	lapack? (
		|| (
			virtual/lapack[eselect-ldso(+)]
			virtual/lapack[flexiblas(-)]
		)
	)
	mysql? ( dev-db/mysql-connector-c:= )
	netcdf? ( sci-libs/netcdf:= )
	odbc? ( dev-db/unixODBC )
	opencl? ( virtual/opencl )
	opengl? ( virtual/opengl )
	pdal? ( >=sci-libs/pdal-2.0.0:= )
	png? ( media-libs/libpng:= )
	postgres? ( >=dev-db/postgresql-8.4:= )
	readline? ( sys-libs/readline:= )
	sqlite? ( dev-db/sqlite:3 )
	svm? ( sci-libs/libsvm:= )
	tiff? ( media-libs/tiff:= )
	truetype? ( media-libs/freetype:2 )
	X? (
		$(python_gen_cond_dep '
			>=dev-python/matplotlib-1.2[wxwidgets,${PYTHON_USEDEP}]
			dev-python/pillow[${PYTHON_USEDEP}]
			>=dev-python/wxpython-4.1:4.0[${PYTHON_USEDEP}]
		')
		x11-libs/cairo[X]
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXt
	)
	zstd? ( app-arch/zstd:= )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	sys-devel/gettext
	virtual/pkgconfig
	X? ( dev-lang/swig )"

RESTRICT="test"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use lapack && has_version "virtual/lapack[eselect-ldso(+)]"; then
		local mylapack=$(eselect lapack show)
		if [[ -z "${mylapack/.*reference.*/}" ]] && \
			[[ -z "${mylapack/.*atlas.*/}" ]]; then
			ewarn "You need to set lapack to atlas or reference. Do:"
			ewarn "   eselect lapack set <impl>"
			ewarn "where <impl> is atlas, threaded-atlas or reference"
			die "setup failed"
		fi
	fi

	if use blas && has_version "virtual/blas[eselect-ldso(+)]"; then
		local myblas=$(eselect blas show)
		if [[ -z "${myblas/.*reference.*/}" ]] && \
			[[ -z "${myblas/.*atlas.*/}" ]]; then
			ewarn "You need to set blas to atlas or reference. Do:"
			ewarn "   eselect blas set <impl>"
			ewarn "where <impl> is atlas, threaded-atlas or reference"
			die "setup failed"
		fi
	fi

	python-single-r1_pkg_setup
}

src_prepare() {
	# Fix unversioned python calls
	sed -e "s:=python3:=${EPYTHON}:" -i "${S}/lib/init/grass.sh" || die
	sed -e "s:= python3:= ${EPYTHON}:" -i "${S}/include/Make/Platform.make.in" || die

	cmake_src_prepare

	ebegin "Fixing python shebangs"
	python_fix_shebang -q "${S}"
	eend $? || die
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/862579
	# https://github.com/OSGeo/grass/issues/3506
	#
	# Do not trust it with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DWITH_X11=$(usex X)
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_CAIRO=$(usex X)
		-DWITH_LIBPNG=$(usex png)
		-DWITH_SQLITE=$(usex sqlite)
		-DWITH_POSTGRES=$(usex postgres)
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_ODBC=$(usex odbc)
		-DWITH_ZSTD=$(usex zstd)
		-DWITH_BZLIB=$(usex bzip2)
		-DWITH_READLINE=$(usex readline)
		-DWITH_FREETYPE=$(usex truetype)
		-DWITH_NLS=$(usex nls)
		-DWITH_FFTW=$(usex fftw)
		-DWITH_CBLAS=$(usex blas)
		-DWITH_LAPACKE=$(usex lapack)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_LIBSVM=$(usex svm)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_NETCDF=$(usex netcdf)
		-DWITH_GEOS=$(usex geos)
		-DWITH_PDAL=$(usex pdal)
		-DWITH_LIBLAS=OFF
		-DWITH_LARGEFILES=$(usex lfs)
		-DWITH_DOCS=$(usex doc)
		-DWITH_GUI=$(usex X)
		-DWITH_FHS=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	pushd "${ED}"/usr/$(get_libdir)/${MY_PM} >/dev/null || die

	local HTML_DOCS=( docs/html/. )
	einstalldocs

	popd >/dev/null || die

	# link libraries in the ~standard~ place
	local f file
	for f in "${ED}"/usr/$(get_libdir)/${MY_PM}/lib/*; do
		file="${f##*/}"
		dosym ${MY_PM}/lib/${file} /usr/$(get_libdir)/${file}
	done

	# link headers in the ~standard~ place
	dodir /usr/include/
	dosym ../$(get_libdir)/${MY_PM}/include/grass /usr/include/grass

	if use X; then
		make_desktop_entry --eapi9 grass -a "--gui" -n "${PN}" -i "${PN}-48x48" -c "Science;Education"
		doicon -s 48 gui/icons/${PN}-48x48.png
	fi
}

pkg_postinst() {
	use X && xdg_pkg_postinst
}

pkg_postrm() {
	use X && xdg_pkg_postrm
}
