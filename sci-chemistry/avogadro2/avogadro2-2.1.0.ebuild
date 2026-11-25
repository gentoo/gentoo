# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit cmake optfeature python-any-r1 xdg

MY_PN=avogadroapp
DESCRIPTION="Advanced molecule editor and visualizer 2"
HOMEPAGE="https://www.openchemistry.org/ https://two.avogadro.cc/"
SRC_URI="
	https://github.com/OpenChemistry/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OpenChemistry/avogadro-i18n/archive/${PV}.tar.gz -> ${P}-i18n.tar.gz
	test? ( https://github.com/OpenChemistry/avogadrodata/archive/${PV}.tar.gz -> ${P}-data.tar.gz )
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc rpc test"
REQUIRED_USE="test? ( rpc )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:=
	dev-qt/qtbase:6[concurrent,gui,network,opengl,ssl,widgets]
	~sci-libs/avogadrolibs-${PV}[archive,python,qt6]
	test? ( dev-qt/qtbase:6[wayland] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-text/doxygen )
	test? (
		dev-libs/weston[desktop,headless]
		$(python_gen_any_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
			sci-libs/avogadrolibs[${PYTHON_SINGLE_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-skip_paraview_tests.patch
)

python_check_deps() {
	python_has_version "dev-python/pytest[${PYTHON_USEDEP}]" &&
	python_has_version "sci-libs/avogadrolibs[python,${PYTHON_SINGLE_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	default
	ln -sfT "${WORKDIR}"/avogadro-i18n-${PV} "${WORKDIR}"/avogadro-i18n || die
	if use test; then
		ln -sfT "${WORKDIR}"/avogadrodata-${PV} "${WORKDIR}"/avogadrodata || die
	fi
}

src_prepare() {
	if use doc; then
		doxygen -u docs/doxyfile.in 2>/dev/null || die
	fi

	# disable automatic update dialog
	sed -e '\@  checkUpdate()@s:^:  //:' \
		-i avogadro/mainwindow.cpp || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DAVOGADRO_RELEASE_BUILD=ON
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DAvogadro_ENABLE_RPC=$(usex rpc)
		-DENABLE_TESTING=$(usex test)
		-DQT_VERSION=6
		# skip detection of jkqtplotter
		# avogadrolibs handles it without the need for rebuilding avogadro2
		-DUSE_PLOTTER=OFF
	)

	# Need this to prevent overwriting the documentation OUTDIR
	use doc && mycmakeargs+=(
			-DChemData_SOURCE_DIR="${S}"
			-DChemData_BINARY_DIR="${BUILD_DIR}"
	)

	cmake_src_configure
}

virt_weston() {
	[[ $# -lt 1 ]] && die "${FUNCNAME} needs at least one argument"

	xdg_environment_reset
	export WAYLAND_DISPLAY="${P}-weston"
	local logfile="${T}/${WAYLAND_DISPLAY}.log"
	local retval=0
	local westonargs=(
		--backend="headless-backend.so"
		--socket="${WAYLAND_DISPLAY}"
		--idle-time="0"
	)
	weston "${westonargs[@]}" 2>"${logfile}" &
	local pid=$!

	local i
	for (( i=0; i<10; i++ )); do
		[[ -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]] && break
		sleep 0.5
	done
	if (( i == 10 )); then
		cat "${logfile}"
		die "Weston failed to start"
	fi

	einfo "Weston started"
	nonfatal "$@"
	retval=$?

	kill "${pid}"

	[[ ${retval} -ne 0 ]] && die "Failed to run '$@'"

	return 0
}

src_test() {
	local -x AVOGADRO_DATA_ROOT="${WORKDIR}"/avogadrodata/
	local -x AVOGADRO_CRYSTALS_DIR="${ESYSROOT}"/usr/share/avogadro2/crystals/
	local -x AVOGADRO_MOLECULES_DIR="${ESYSROOT}"/usr/share/avogadro2/molecules/
	local -x AVOGADRO_PYTHON_DIR=$(python_get_sitedir)
	local CMAKE_SKIP_TESTS=(
		# skip tests with paraview requirement
		avogadro-basic-drawing
	)

	virt_weston cmake_src_test -j1
}

src_compile() {
	cmake_src_compile

	use doc && cmake_build documentation
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )

	cmake_src_install

	# remove CONTRIBUTING, LICENSE and duplicate README
	rm -r "${ED}"/usr/share/doc/${PF}/avogadro2 || die
}

pkg_postinst() {
	optfeature "environments of downloaded plugins" dev-util/pixi
	optfeature "charts and spectra" sci-libs/avogadrolibs[jkqtplotter]

	xdg_pkg_postinst
}
