# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 scons-utils toolchain-funcs udev multilib-minimal

DESCRIPTION="Driver for IEEE1394 (Firewire) audio interfaces"
HOMEPAGE="http://www.ffado.org"

if [ "${PV}" = "9999" ]; then
	inherit subversion
	ESVN_REPO_URI="http://subversion.ffado.org/ffado/trunk/${PN}"
	KEYWORDS="~arm ~arm64 ~ia64 ~ppc ~ppc64"
else
	SRC_URI="http://www.ffado.org/files/${P}.tgz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64"
fi

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="debug qt4 test-programs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-cpp/libxmlpp:2.6[${MULTILIB_USEDEP}]
	dev-libs/dbus-c++
	dev-libs/libconfig[cxx,${MULTILIB_USEDEP}]
	media-libs/alsa-lib
	media-libs/libiec61883[${MULTILIB_USEDEP}]
	!<media-sound/jack-audio-connection-kit-0.122.0:0
	!<media-sound/jack-audio-connection-kit-1.9.9:2
	sys-apps/dbus
	sys-libs/libraw1394[${MULTILIB_USEDEP}]
	sys-libs/libavc1394[${MULTILIB_USEDEP}]
	${PYTHON_DEPS}
	qt4? (
		dev-python/PyQt4[dbus,${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		x11-misc/xdg-utils
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/libffado-2.3.0-modelname-strip.patch"
	"${FILESDIR}/libffado-2.3.0-gcc6.patch"
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
			BUILD_MIXER=$(usex qt4 true false)
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

	if use qt4; then
		newicon "support/xdg/hi64-apps-ffado.png" "ffado.png"
		newmenu "support/xdg/ffado.org-ffadomixer.desktop" "ffado-mixer.desktop"
	fi
}
