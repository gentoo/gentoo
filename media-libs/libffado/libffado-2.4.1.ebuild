# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 python3_6 )

inherit desktop python-single-r1 scons-utils toolchain-funcs udev multilib-minimal

DESCRIPTION="Driver for IEEE1394 (Firewire) audio interfaces"
HOMEPAGE="http://www.ffado.org"

if [[ "${PV}" = "9999" ]]; then
	inherit subversion
	ESVN_REPO_URI="http://subversion.ffado.org/ffado/trunk/${PN}"
else
	SRC_URI="http://www.ffado.org/files/${P}.tgz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
fi

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="debug qt5 test-programs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-cpp/libxmlpp:2.6[${MULTILIB_USEDEP}]
	dev-libs/dbus-c++
	dev-libs/libconfig[cxx,${MULTILIB_USEDEP}]
	media-libs/alsa-lib
	media-libs/libiec61883[${MULTILIB_USEDEP}]
	sys-apps/dbus
	sys-libs/libavc1394[${MULTILIB_USEDEP}]
	sys-libs/libraw1394[${MULTILIB_USEDEP}]
	qt5? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/PyQt5[dbus,${PYTHON_USEDEP}]
		x11-misc/xdg-utils
	)"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	!<media-sound/jack-audio-connection-kit-0.122.0:0
	!<media-sound/jack-audio-connection-kit-1.9.9:2"

PATCHES=(
	"${FILESDIR}/${P}-python3-scons-fix.patch"
)

myescons() {
	local myesconsargs=(
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"
		UDEVDIR="$(get_udevdir)/rules.d"
		CUSTOM_ENV=true
		DETECT_USERSPACE_ENV=false
		DEBUG=$(usex debug)
		PYPKGDIR="$(python_get_sitedir)"
		# ENABLE_OPTIMIZATIONS detects cpu type and sets flags accordingly
		# -fomit-frame-pointer is added also which can cripple debugging.
		# we set flags from portage instead
		ENABLE_OPTIMIZATIONS=false
		# This only works for JACK1>=0.122.0 or JACK2>=1.9.9, so we block
		# lower versions.
		ENABLE_SETBUFFERSIZE_API_VER=force
	)
	if multilib_is_native_abi; then
		myesconsargs+=(
			BUILD_MIXER=$(usex qt5 true false)
			BUILD_TESTS=$(usex test-programs)
		)
	else
		myesconsargs+=(
			BUILD_MIXER=false
			BUILD_TESTS=false
		)
	fi
	escons "${myesconsargs[@]}" "${@}"
}

src_prepare() {
	default

	# Always use Qt5
	sed -i -e 's/try:/if False:/' -e 's/except.*/else:/' support/mixer-qt4/ffado/import_pyqt.py || die

	# Bugs #658052, #659226
	sed -i -e 's/^CacheDir/#CacheDir/' SConstruct || die

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CC CXX
	myescons
}

multilib_src_install() {
	myescons DESTDIR="${D}" WILL_DEAL_WITH_XDG_MYSELF="True" install
}

multilib_src_install_all() {
	einstalldocs

	python_fix_shebang "${D}"
	python_optimize "${D}"

	if use qt5; then
		newicon "support/xdg/hi64-apps-ffado.png" "ffado.png"
		newmenu "support/xdg/ffado.org-ffadomixer.desktop" "ffado-mixer.desktop"
	fi
}
