# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="sqlite"  # bug 572440

inherit desktop flag-o-matic python-single-r1 toolchain-funcs xdg

DESCRIPTION="A free GIS with raster and vector functionality, as well as 3D vizualization"
HOMEPAGE="https://grass.osgeo.org/"

LICENSE="GPL-2"

if [[ ${PV} =~ "9999" ]]; then
	SLOT="0/8.4"
else
	SLOT="0/$(ver_cut 1-2 ${PV})"
fi

GVERSION=${SLOT#*/}
MY_PM="${PN}${GVERSION}"
MY_PM="${MY_PM/.}"

if [[ ${PV} =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OSGeo/grass.git"
else
	MY_P="${P/_rc/RC}"
	SRC_URI="https://grass.osgeo.org/${MY_PM}/source/${MY_P}.tar.gz"
	if [[ ${PV} != *_rc* ]] ; then
		KEYWORDS="~amd64 ~ppc ~x86"
	fi

	S="${WORKDIR}/${MY_P}"
fi

IUSE="blas bzip2 cxx fftw geos lapack las mysql netcdf nls odbc opencl opengl openmp pdal png postgres readline sqlite svm threads tiff truetype X zstd"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	opengl? ( X )"

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
	sys-libs/zlib
	media-libs/libglvnd
	media-libs/glu
	blas? (
		virtual/cblas[eselect-ldso(+)]
		virtual/blas[eselect-ldso(+)]
	)
	bzip2? ( app-arch/bzip2:= )
	fftw? ( sci-libs/fftw:3.0= )
	geos? ( sci-libs/geos:= )
	lapack? ( virtual/lapack[eselect-ldso(+)] )
	las? ( sci-geosciences/liblas )
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

PATCHES=(
	# bug 746590
	"${FILESDIR}/${PN}-flock.patch"
)

pkg_setup() {
	if use lapack; then
		local mylapack=$(eselect lapack show)
		if [[ -z "${mylapack/.*reference.*/}" ]] && \
			[[ -z "${mylapack/.*atlas.*/}" ]]; then
			ewarn "You need to set lapack to atlas or reference. Do:"
			ewarn "   eselect lapack set <impl>"
			ewarn "where <impl> is atlas, threaded-atlas or reference"
			die "setup failed"
		fi
	fi

	if use blas; then
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

	default

	# When patching the build system, avoid running autoheader here. The file
	# config.in.h is maintained manually upstream. Changes to it may lead to
	# undefined behavior. See bug #866554.
	# AT_NOEAUTOHEADER=1 eautoreconf

	ebegin "Fixing python shebangs"
	python_fix_shebang -q "${S}"
	eend $?

	# For testsuite, see https://bugs.gentoo.org/show_bug.cgi?id=500580#c3
	shopt -s nullglob
	local mesa_cards=$(echo -n /dev/dri/card* /dev/dri/render* | sed 's/ /:/g')
	if test -n "${mesa_cards}"; then
		addpredict "${mesa_cards}"
	fi
	local ati_cards=$(echo -n /dev/ati/card* | sed 's/ /:/g')
	if test -n "${ati_cards}"; then
		addpredict "${ati_cards}"
	fi
	shopt -u nullglob
	addpredict /dev/nvidiactl
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/862579
	# https://github.com/OSGeo/grass/issues/3506
	#
	# Do not trust it with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	addwrite /dev/dri/renderD128

	local myeconfargs=(
		--enable-shared
		--disable-w11
		--without-opendwg
		--with-regex
		--with-gdal="${EPREFIX}"/usr/bin/gdal-config
		--with-proj-includes="${EPREFIX}"/usr/include/proj
		--with-proj-libs="${EPREFIX}"/usr/$(get_libdir)
		--with-proj-share="${EPREFIX}"/usr/share/proj/
		$(use_with cxx)
		$(use_with tiff)
		$(use_with png libpng "${EPREFIX}"/usr/bin/libpng-config)
		$(use_with postgres)
		$(use_with mysql)
		$(use_with mysql mysql-includes "${EPREFIX}"/usr/include/mysql)
		$(use_with sqlite)
		$(use_with opengl)
		$(use_with odbc)
		$(use_with fftw)
		$(use_with blas)
		$(use_with lapack)
		$(use_with X cairo)
		$(use_with truetype freetype)
		$(use_with truetype freetype-includes "${EPREFIX}"/usr/include/freetype2)
		$(use_with nls)
		$(use_with readline)
		$(use_with threads pthread)
		$(use_with openmp)
		$(use_with opencl)
		$(use_with bzip2 bzlib)
		$(use_with pdal pdal "${EPREFIX}"/usr/bin/pdal-config)
		$(use_with las liblas "${EPREFIX}"/usr/bin/liblas-config)
		$(use_with netcdf netcdf "${EPREFIX}"/usr/bin/nc-config)
		$(use_with geos geos "${EPREFIX}"/usr/bin/geos-config)
		$(use_with svm libsvm)
		$(use_with X x)
		$(use_with zstd)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# we don't want to link against embedded mysql lib
	emake CC="$(tc-getCC)" MYSQLDLIB=""
}

src_install() {
	emake DESTDIR="${ED}" \
		INST_DIR=/usr/$(get_libdir)/${MY_PM} \
		prefix=/usr/ BINDIR=/usr/bin \
		install

	pushd "${ED}"/usr/$(get_libdir)/${MY_PM} >/dev/null || die

	local HTML_DOCS=( docs/html/. )
	einstalldocs

	# translations
	if use nls; then
		insinto /usr/share/locale
		doins -r locale/.
	fi

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

	# set proper python interpreter
	sed -e "s:os.environ\[\"GRASS_PYTHON\"\] = \"python3\":\
os.environ\[\"GRASS_PYTHON\"\] = \"${EPYTHON}\":" \
		-i "${ED}"/usr/bin/grass || die

	if use X; then
		local GUI="--gui"
		make_desktop_entry "/usr/bin/grass ${GUI}" "${PN}" "${PN}-48x48" "Science;Education"
		doicon -s 48 gui/icons/${PN}-48x48.png
	fi

	# install .pc file so other apps know where to look for grass
	insinto /usr/$(get_libdir)/pkgconfig/
	doins grass.pc

	# fix weird +x on tcl scripts
	find "${ED}" -name "*.tcl" -exec chmod +r-x '{}' \; || die
}

pkg_postinst() {
	use X && xdg_pkg_postinst
}

pkg_postrm() {
	use X && xdg_pkg_postrm
}
