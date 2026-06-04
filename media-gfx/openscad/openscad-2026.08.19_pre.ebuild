# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# verify QT_XCB_GL_INTEGRATION= breakage via alaric/SeanFenian

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit cmake flag-o-matic optfeature python-single-r1 virtualx xdg

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="https://openscad.org/"

# TODO
# NOTE the build system sets up a venv for tests, we could use imagemagick with -DUSE_IMAGE_COMPARE_PY="no"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openscad/openscad.git"
	EGIT_SUBMODULES=(
		'*'
		'-Clipper2'
		'-mimalloc'
		'-submodules/manifold'
		'-OpenCSG'
	)
else
	if [[ ${PV} = *pre* ]] ; then
		COMMIT="019c069c3c07ed9c280e643f2c156104736cebd0"
		SANITIZERS_CMAKE_COMMIT="bcb1fc68616e9645ca5acea2992412606373ab04"
		MCAD_COMMIT="1ea402208c3127ffb443931e9bb1681c191dacca"

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
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

# Code is GPL-3+, MCAD library is LGPL-2.1
LICENSE="GPL-3+ LGPL-2.1"
SLOT="0"

IUSE="+cgal dbus +egl experimental glx +gui hidapi +manifold mimalloc pdf +python spacenav test"
RESTRICT="!test? ( test )"
	# ?? ( glad glew )
	# || ( cgal manifold )
REQUIRED_USE="
	|| ( egl glx )
	dbus? ( gui )
	hidapi? ( gui )
	manifold? ( cgal )
	python? ( ${PYTHON_REQUIRED_USE} )
	spacenav? ( gui )
"

RDEPEND="
	dev-cpp/eigen:=
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
	>=sci-mathematics/clipper2-1.5.2:=
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
	python? (
		${PYTHON_DEPS}
		dev-libs/nettle:=
	)
	spacenav? ( dev-libs/libspnav )
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-cpp/catch-3
	)
"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/pillow[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
		')
		gui-wm/tinywl
		python? (
			${PYTHON_DEPS}
		)
		!python? (
			media-gfx/imagemagick
		)
	)
"

DOCS=(
	README.md
	RELEASE_NOTES.md
	doc/contributor_copyright.txt
	# doc/hacking.md
	# doc/testing.md
	doc/translation.txt
)

# NOTE the build system sets up a venv for tests, we could use imagemagick with -DUSE_IMAGE_COMPARE_PY="no"
python_check_deps() {
	python_has_version -b \
		"dev-python/numpy[${PYTHON_USEDEP}]" \
		"dev-python/pillow[${PYTHON_USEDEP}]" \
		"dev-python/pip[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if use python || use test ; then
		python-single-r1_pkg_setup
	fi
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
		-DINFO="yes"
		-DUSE_MANIFOLD_TRIANGULATOR="$(usex manifold)"
		-DUSE_MANIFOLD_MINKOWSKI="$(usex manifold "no")" # experimental
		-DBUILD_SHARED_LIBS="yes"

		-DCLANG_TIDY="no"
		-DENABLE_CAIRO="$(usex pdf)"
		-DENABLE_CGAL="$(usex cgal)"
		-DENABLE_EGL="$(usex egl)"
		-DENABLE_GAMEPAD="no"
		-DENABLE_GLX="$(usex glx)"
		-DENABLE_MANIFOLD="$(usex manifold)"
		-DENABLE_PYTHON="$(usex python)"
		-DENABLE_TESTS="$(usex test)"

		-DEXPERIMENTAL="$(usex experimental)"

		-DUSE_BUILTIN_CLIPPER2="no"
		-DUSE_BUILTIN_MANIFOLD="no"
		-DUSE_BUILTIN_OPENCSG="no"

		-DUSE_CCACHE="no"

		# For now, we'll default to whatever OpenCSG uses (>=1.6 -> GLAD, <1.6 -> GLEW)
		-DUSE_GLAD="$(usex gui)"
		-DUSE_GLEW="no"
		-DHEADLESS="$(usex !gui)"
		-DNULLGL="$(usex !gui)"

		-DUSE_IMAGE_COMPARE_PY="$(usex python)"
		-DUSE_MIMALLOC="$(usex mimalloc)"
		-DUSE_QT6="$(usex gui)"
		-DOFFLINE_DOCS="no" # TODO
		-DOPENCSG_DIR="${EPREFIX}/usr/$(get_libdir)"
	)

	if use gui; then
		mycmakeargs+=(
			-DENABLE_HIDAPI="$(usex hidapi)"
			-DENABLE_GUI_TESTS="$(usex gui)"
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

hardware_add_gpu_sandbox() {
	local dri cards PREDICT=() WRITE=()

	# mesa will make use of udmabuf if it exists
	if [[ -c "/dev/udmabuf" ]]; then
		WRITE+=(
			"/dev/udmabuf"
		)
	fi

	# /dev/dri/card[%d]
	# /dev/dri/renderD[128+%d]
	readarray -t dri <<<"$(
		find /sys/class/drm/*/device/drm \
			-mindepth 1 -maxdepth 1 -type d -exec basename {} \; \
			| sort | uniq | sed 's:^:/dev/dri/:'
	)"

	[[ -n "${dri[*]}" ]] && WRITE+=( "${dri[@]}" )

	if [[ -d /sys/module/nvidia ]]; then
		# stat --printf="%Hr:%Lr"
		PREDICT+=(
			# /dev/char/195:X   # ../nvidiaX
			# /dev/char/195:254 # ../nvidia-modeset
			# /dev/char/195:255 # ../nvidiactl
			/dev/char/
		)

		# /dev/nvidia{0-9}
		readarray -t nvidia_devs <<<"$(
			find /dev -regextype posix-extended  -regex '/dev/nvidia(|-(nvswitch|vgpu))[0-9]*'
		)"
		[[ -n "${nvidia_devs[*]}" ]] && WRITE+=( "${nvidia_devs[@]}" )

		WRITE+=(
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

	local dev
	for dev in "${WRITE[@]}"; do
		if [[ ! -e "${dev}" ]]; then
			eqawarn "${dev} does not exist"
			continue
		fi

		if [[ -w "${dev}" ]]; then
			eqawarn "${dev} is already writable"
			continue
		fi

		addwrite "${dev}"

		if [[ ! -d "${dev}" ]] && [[ ! -w "${dev}" ]]; then
			eerror "can not access ${dev} after addwrite"
		fi
	done

	for dev in "${PREDICT[@]}"; do
		if [[ ! -e "${dev}" ]]; then
			eqawarn "${dev} does not exist"
			continue
		fi

		addpredict "${dev}"
	done
}

virtwl() {
	debug-print-function "${FUNCNAME[0]}" "$@"

	[[ $# -lt 1 ]] && die "${FUNCNAME[0]} needs at least one argument"

	# [[ -n $XDG_RUNTIME_DIR ]] || die "${FUNCNAME[0]} needs XDG_RUNTIME_DIR to be set; try xdg_environment_reset"

	tinywl -h >/dev/null || die 'tinywl -h failed'

	local VIRTWL VIRTWL_PID
	coproc VIRTWL { WLR_BACKENDS=headless exec tinywl -s 'echo $WAYLAND_DISPLAY; read _; kill $PPID'; }
	local -x WAYLAND_DISPLAY
	read -r WAYLAND_DISPLAY <&"${VIRTWL[0]}"

	debug-print "${FUNCNAME[0]}: $*"
	nonfatal "${@}"
	local r="${?}"

	[[ -n $VIRTWL_PID ]] || die "tinywl exited unexpectedly"
	exec {VIRTWL[0]}<&- {VIRTWL[1]}>&-

	if [[ "${r}" -ne 0 ]]; then
		die -n "${*} failed"
	fi

	return "${r}"
}

src_test() {
	hardware_add_gpu_sandbox

	sed \
		-e "s/OPENSCAD_BINARY/OPENSCADPATH/g" \
		-i tests/test_cmdline_tool.py || die

	cd "${BUILD_DIR}" || die

	# NOTE link in from CMAKE_USE_DIR
	ln -s "${CMAKE_USE_DIR}/color-schemes" . || die
	ln -s "${CMAKE_USE_DIR}/locale" . || die
	ln -s "${CMAKE_USE_DIR}/shaders" . || die

	local CMAKE_SKIP_TESTS=(
		# just skip all issue tests all together
		# "_issue[0-9]*$"

		# fails
		"_spec-paths-arcs01$"
		"_issue6607$"
	)

	if ! has_version app-text/ghostscript-gpl ; then
		CMAKE_SKIP_TESTS+=(
			# needs GS
			"^export-pdf_centered$"
			"^export-pdf_simple-pdf$"
		)
	fi

	local -x GIT_DIR="${CMAKE_USE_DIR}/.git"

	if use egl; then
		xdg_environment_reset
		virtwl cmake_src_test
	else
		virtx cmake_src_test
	fi
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
