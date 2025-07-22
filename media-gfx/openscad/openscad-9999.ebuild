# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit cmake flag-o-matic optfeature python-any-r1 virtualx xdg

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="https://openscad.org/"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openscad/openscad.git"
	EGIT_SUBMODULES=(
		'*'
		'-mimalloc'
		'-submodules/manifold'
		'-OpenCSG'
	)
else
	if [[ ${PV} = *pre* ]] ; then
		COMMIT="f3cac59bf973502ad4b278fd3f20298f9bc2fc84"
		SANITIZERS_CMAKE_COMMIT="0573e2ea8651b9bb3083f193c41eb086497cc80a"
		MCAD_COMMIT="bd0a7ba3f042bfbced5ca1894b236cea08904e26"

		SRC_URI="
			https://github.com/openscad/openscad/archive/${COMMIT}.tar.gz
				-> ${P}.tar.gz
			https://github.com/arsenm/sanitizers-cmake/archive/${SANITIZERS_CMAKE_COMMIT}.tar.gz
				-> sanitizers-cmake-${SANITIZERS_CMAKE_COMMIT}.tar.gz
			test? (
				https://github.com/openscad/MCAD/archive/${MCAD_COMMIT}.tar.gz -> ${PN}-MCAD-${MCAD_COMMIT}.tar.gz
			)
		"
		# doc downloads are not versioned and found at:
		# https://files.openscad.org/documentation/
		S="${WORKDIR}/${PN}-${COMMIT}"
	else
		SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.src.tar.gz -> ${P}.tar.gz"
	fi
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

# Code is GPL-3+, MCAD library is LGPL-2.1
LICENSE="GPL-3+ LGPL-2.1"
SLOT="0"

IUSE="cgal dbus +egl experimental glx +gui hidapi +manifold mimalloc pdf spacenav test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	|| ( cgal manifold )
	dbus? ( gui )
	hidapi? ( gui )
	spacenav? ( gui )
	|| ( egl glx )
"

RDEPEND="
	dev-libs/boost:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libxml2:=
	dev-libs/libzip:=
	>=media-gfx/opencsg-1.7.0:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lib3mf:=
	media-libs/libglvnd
	>=sci-mathematics/clipper2-1.5.2
	cgal? (
		sci-mathematics/cgal:=
	)
	glx? (
		media-libs/libglvnd[X]
	)
	gui? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[concurrent,dbus?,-gles2-only,network,opengl,widgets]
		dev-qt/qtmultimedia:6
		dev-qt/qtsvg:6
		>=x11-libs/qscintilla-2.14.1-r1:=[qt6(+)]
	)
	hidapi? ( dev-libs/hidapi )
	manifold? (
		dev-cpp/tbb:=
		>=sci-mathematics/manifold-3.0.2_pre20250330:=
	)
	mimalloc? ( dev-libs/mimalloc:= )
	pdf? ( x11-libs/cairo )
	spacenav? ( dev-libs/libspnav )
"
DEPEND="
	${RDEPEND}
	dev-cpp/eigen:3
"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		$(python_gen_any_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pillow[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
		')
	)
"

DOCS=(
	README.md
	RELEASE_NOTES.md
	doc/contributor_copyright.txt
	doc/hacking.md
	doc/testing.txt
	doc/translation.txt
)

# NOTE the build system sets up a venv for tests, we could use imagemagick with -DUSE_IMAGE_COMPARE_PY="no"
python_check_deps() {
	python_has_version "dev-python/numpy[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pillow[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/pip[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	if use test && [[ ${PV} != *9999* ]] ; then
		mv -f "${WORKDIR}/MCAD-${MCAD_COMMIT}"/* "${S}/libraries/MCAD/" || die
	fi

	# NOTE adhere CMP0167
	# https://cmake.org/cmake/help/latest/policy/CMP0167.html
	sed \
		-e '/find_package(Boost/s/)/ CONFIG)/g' \
		-i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=odr
	# https://github.com/openscad/openscad/issues/5239
	filter-lto

	local mycmakeargs=(
		-DCLANG_TIDY="no"
		-DENABLE_CAIRO="$(usex pdf)"
		-DENABLE_CGAL="$(usex cgal)"
		-DENABLE_EGL="$(usex egl)"
		-DENABLE_GLX="$(usex glx)"
		-DENABLE_MANIFOLD="$(usex manifold)"
		-DENABLE_PYTHON="no"
		-DENABLE_TESTS="$(usex test)"

		-DEXPERIMENTAL="$(usex experimental)"

		-DHEADLESS="$(usex !gui)"
		-DUSE_BUILTIN_CLIPPER2="no"
		-DUSE_BUILTIN_MANIFOLD="no"
		-DUSE_CCACHE="no"
		-DUSE_GLAD="yes"
		-DUSE_GLEW="no"
		-DUSE_MIMALLOC="$(usex mimalloc)"
		-DUSE_QT6="$(usex gui)"
		-DOFFLINE_DOCS="no" # TODO
		-DOPENCSG_DIR="${EPREFIX}/usr/$(get_libdir)"
	)

	if use gui; then
		mycmakeargs+=(
			-DENABLE_HIDAPI="$(usex hidapi)"
			-DENABLE_QTDBUS="$(usex dbus)"
			-DENABLE_SPNAV="$(usex spacenav)"
		)
	fi

	if [[ ${PV} != *9999* ]] ; then
		mycmakeargs+=(
			-DCMAKE_MODULE_PATH="${WORKDIR}/sanitizers-cmake-${SANITIZERS_CMAKE_COMMIT}/cmake"
		)
		if [[ ${PV} = *pre* ]] ; then
			mycmakeargs+=(
				-DOPENSCAD_COMMIT="${COMMIT:0:9}"
				-DOPENSCAD_VERSION="$(ver_cut 1-3)"
				-DSNAPSHOT="yes"
			)
		fi
	else
		mycmakeargs+=(
			-DOPENSCAD_COMMIT="${COMMIT:0:9}"
			-DSNAPSHOT="yes"
		)
	fi

	cmake_src_configure
}

src_test() {
	local i WRITE=()

	# mesa will make use of udmabuf if it exists
	if [[ -c "/dev/udmabuf" ]]; then
		WRITE+=(
			"/dev/udmabuf"
		)
	fi

	if [[ -d /sys/module/nvidia ]]; then
		# /dev/dri/card*
		# /dev/dri/renderD*
		readarray -t dri <<<"$(
			find /sys/module/nvidia/drivers/*/*:*:*.*/drm \
				-mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
				| sed 's:^:/dev/dri/:'
			)"

		# /dev/nvidia{0-9}
		readarray -t cards <<<"$(find /dev -regextype sed -regex '/dev/nvidia[0-9]*')"

		WRITE+=(
			"${dri[@]}"
			"${cards[@]}"
			"/dev/nvidiactl"
			"/dev/nvidia-caps/"
			"/dev/nvidia-modeset"
			"/dev/nvidia-uvm"
			"/dev/nvidia-uvm-tools"
		)
	fi

	WRITE+=(
		# for portage
		"/proc/self/task/"
	)
	for i in "${WRITE[@]}"; do
		if [[ ! -w "$i" ]]; then
			eqawarn "addwrite $i"
			addwrite "$i"

			if [[ ! -d "$i" ]] && [[ ! -w "$i" ]]; then
				eqawarn "can not access $i after addwrite"
			fi
		fi
	done

	addpredict "/dev/char/"

	sed \
		-e "s/OPENSCAD_BINARY/OPENSCADPATH/g" \
		-i tests/test_cmdline_tool.py || die

	cd "${BUILD_DIR}" || die

	# NOTE link in from CMAKE_USE_DIR
	ln -s "${CMAKE_USE_DIR}/color-schemes" . || die
	ln -s "${CMAKE_USE_DIR}/locale" . || die
	ln -s "${CMAKE_USE_DIR}/shaders" . || die

	local -x CMAKE_SKIP_TESTS=()

	if ! has_version app-text/ghostscript-gpl ; then
		CMAKE_SKIP_TESTS+=(
			# needs GS
			"^export-pdf_centered$"
			"^export-pdf_simple-pdf$"
		)
	fi

	virtx cmake_src_test
}

src_install() {
	DOCS+=( doc/*.pdf )

	cmake_src_install

	mv -i "${ED}"/usr/share/openscad/locale "${ED}"/usr/share || die "failed to move locales"
	dosym -r /usr/share/locale /usr/share/openscad/locale
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "support scad major mode in GNU Emacs" app-emacs/scad-mode
}
