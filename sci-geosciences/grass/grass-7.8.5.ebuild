# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE="sqlite"  # bug 572440
WANT_AUTOCONF="2.1"
WX_GTK_VER="3.0-gtk3"

inherit autotools desktop flag-o-matic python-single-r1 toolchain-funcs wxwidgets xdg

MY_PM=${PN}$(ver_cut 1-2 ${PV})
MY_PM=${MY_PM/.}
MY_P=${P/_rc/RC}

DESCRIPTION="A free GIS with raster and vector functionality, as well as 3D vizualization"
HOMEPAGE="https://grass.osgeo.org/"
SRC_URI="https://grass.osgeo.org/${MY_PM}/source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/7.8.0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="blas cxx fftw geos lapack liblas mysql netcdf nls odbc opencl opengl openmp png postgres readline sqlite threads tiff truetype X zstd"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	opengl? ( X )"

RDEPEND="
	${PYTHON_DEPS}
	>=app-admin/eselect-1.2
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	')
	sci-libs/gdal
	sys-libs/gdbm
	sys-libs/ncurses:0=
	sci-libs/proj
	sci-libs/xdrfile
	sys-libs/zlib
	blas? (
		virtual/cblas[eselect-ldso(+)]
		virtual/blas[eselect-ldso(+)]
	)
	fftw? ( sci-libs/fftw:3.0= )
	geos? ( sci-libs/geos )
	lapack? ( virtual/lapack[eselect-ldso(+)] )
	liblas? ( sci-geosciences/liblas )
	mysql? ( dev-db/mysql-connector-c:= )
	netcdf? ( sci-libs/netcdf )
	odbc? ( dev-db/unixODBC )
	opencl? ( virtual/opencl )
	opengl? ( virtual/opengl )
	png? ( media-libs/libpng:0= )
	postgres? ( >=dev-db/postgresql-8.4:= )
	readline? ( sys-libs/readline:0= )
	sqlite? ( dev-db/sqlite:3 )
	tiff? ( media-libs/tiff:0= )
	truetype? ( media-libs/freetype:2 )
	X? (
		dev-python/wxpython:4.0
		x11-libs/cairo[X,opengl?]
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXt
	)
	zstd? ( app-arch/zstd )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	X? ( dev-lang/swig )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# bug 746590
	"${FILESDIR}/${PN}-7.8-flock.patch"
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
	eautoreconf

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
	if use X; then
		local WX_BUILD=yes
		setup-wxwidgets
	fi

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
		$(use_with png)
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
		$(use_with liblas liblas "${EPREFIX}"/usr/bin/liblas-config)
		$(use_with X wxwidgets "${WX_CONFIG}")
		$(use_with netcdf netcdf "${EPREFIX}"/usr/bin/nc-config)
		$(use_with geos geos "${EPREFIX}"/usr/bin/geos-config)
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
		INST_DIR="${ED}"/usr/$(get_libdir)/${MY_PM} \
		prefix="${ED}"/usr/ BINDIR="${ED}"/usr/bin \
		PREFIX="${ED}"/usr/ \
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

	# fix paths in addons makefile includes
	local scriptMakeDir="${ED}"/usr/$(get_libdir)/${MY_PM}/include/Make/
	for f in "${scriptMakeDir}"/*; do
		file="${f##*/}"
		echo sed -i "s|${ED}|/|g" "${scriptMakeDir}/${file}" || die
		sed -i "s|${ED}|/|g" "${scriptMakeDir}/${file}" || die
	done

	# get proper folder for grass path in script
	local gisbase=/usr/$(get_libdir)/${MY_PM}
	sed -e "s:GISBASE = os.path.normpath(\"${D}/usr/$(get_libdir)/${MY_PM}\"):\
GISBASE = os.path.normpath(\"${gisbase}\"):" \
		-i "${ED}"/usr/bin/${MY_PM} || die

	# get proper fonts path for fontcap
	sed -i \
		-e "s|${ED}/usr/${MY_PM}|${EPREFIX}/usr/$(get_libdir)/${MY_PM}|" \
		"${ED}"/usr/$(get_libdir)/${MY_PM}/etc/fontcap || die

	# set proper python interpreter
	sed -e "s:os.environ\['GRASS_PYTHON'\] = \"python3\":\
os.environ\['GRASS_PYTHON'\] = \"${EPYTHON}\":" \
		-i "${ED}"/usr/bin/${MY_PM} || die

	if use X; then
		local GUI="-gui"
		[[ ${WX_BUILD} == yes ]] && GUI="-wxpython"
		make_desktop_entry "/usr/bin/${MY_PM} ${GUI}" "${PN}" "${PN}-48x48" "Science;Education"
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
