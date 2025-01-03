# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic optfeature virtualx xdg

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
	COMMIT="bc0d078e0361d7dba66723ac31bdb3b650ecff37"
	SANITIZERS_CMAKE_COMMIT="3f0542e4e034aab417c51b2b22c94f83355dee15"
	MCAD_COMMIT="bd0a7ba3f042bfbced5ca1894b236cea08904e26"

	SRC_URI="
		https://github.com/openscad/openscad/archive/${COMMIT}.tar.gz
			-> ${PN}-20241114.tar.gz
		https://github.com/arsenm/sanitizers-cmake/archive/${SANITIZERS_CMAKE_COMMIT}.tar.gz
			-> sanitizers-cmake-${SANITIZERS_CMAKE_COMMIT}.tar.gz
		test? (
			https://github.com/openscad/MCAD/archive/${MCAD_COMMIT}.tar.gz -> ${PN}-MCAD-${MCAD_COMMIT}.tar.gz
		)
	"
	# doc downloads are not versioned and found at:
	# https://files.openscad.org/documentation/
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="amd64 ~arm64 ~ppc64 ~x86"
fi

# Code is GPL-3+, MCAD library is LGPL-2.1
LICENSE="GPL-3+ LGPL-2.1"
SLOT="0"

IUSE="dbus +egl experimental glx +gui hidapi +manifold mimalloc pdf spacenav test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	dbus? ( gui )
	hidapi? ( gui )
	spacenav? ( gui )
	|| ( egl glx )
"

RDEPEND="
	dev-libs/boost:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/libzip:=
	media-gfx/opencsg:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lib3mf:=
	sci-mathematics/cgal:=
	media-libs/libglvnd[X]
	gui? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[concurrent,dbus?,-gles2-only,network,opengl,widgets]
		dev-qt/qtmultimedia:6
		dev-qt/qtsvg:6
		x11-libs/qscintilla:=[qt6]
	)
	hidapi? ( dev-libs/hidapi )
	manifold? (
		dev-cpp/tbb
		sci-mathematics/manifold
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
"

DOCS=(
	README.md
	RELEASE_NOTES.md
	doc/TODO.txt
	doc/contributor_copyright.txt
	doc/hacking.md
	doc/testing.txt
	doc/translation.txt
)

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
		-DENABLE_CGAL="yes"
		-DENABLE_EGL="$(usex egl)"
		-DENABLE_GLX="$(usex glx)"
		-DENABLE_MANIFOLD="$(usex manifold)"
		-DENABLE_PYTHON="no"
		-DENABLE_TESTS="$(usex test)"

		-DEXPERIMENTAL="$(usex experimental)"

		-DHEADLESS="$(usex !gui)"
		-DUSE_BUILTIN_MANIFOLD="no"
		-DUSE_CCACHE="no"
		-DUSE_GLAD="yes"
		-DUSE_GLEW="no"
		-DUSE_LEGACY_RENDERERS="no"
		-DUSE_MIMALLOC="$(usex mimalloc)"
		-DUSE_QT6="$(usex gui)"
		-DOFFLINE_DOCS="no" # TODO
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
			-DOPENSCAD_COMMIT="${COMMIT:0:9}"
			-DOPENSCAD_VERSION="${PV:0:4}.${PV:4:2}.${PV:6:2}"
		)
	fi

	cmake_src_configure
}

src_test() {
	local i WRITE=()

	if [[ -d "/dev/udmabuf" ]]; then
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

	sed \
		-e "s/OPENSCAD_BINARY/OPENSCADPATH/g" \
		-i tests/test_cmdline_tool.py || die

	cd "${BUILD_DIR}" || die

	# NOTE link in from CMAKE_USE_DIR
	ln -s "${CMAKE_USE_DIR}/color-schemes" . || die
	ln -s "${CMAKE_USE_DIR}/locale" . || die
	ln -s "${CMAKE_USE_DIR}/shaders" . || die

	virtx cmake_src_test -j1
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
