# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1 scons-utils toolchain-funcs udev multilib-minimal xdg

DESCRIPTION="Driver for IEEE1394 (Firewire) audio interfaces"
HOMEPAGE="https://ffado.org/"

if [[ ${PV} == *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="http://subversion.ffado.org/ffado/trunk/${PN}"
else
	SRC_URI="https://ffado.org/files/${P}.tgz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv x86"
fi

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="debug test-programs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	virtual/pkgconfig
"
RDEPEND="${PYTHON_DEPS}
	dev-cpp/libxmlpp:2.6[${MULTILIB_USEDEP}]
	>=dev-libs/dbus-c++-0.9.0-r5
	dev-libs/libconfig:=[cxx,${MULTILIB_USEDEP}]
	media-libs/alsa-lib
	media-libs/libiec61883[${MULTILIB_USEDEP}]
	sys-apps/dbus
	sys-libs/libavc1394[${MULTILIB_USEDEP}]
	sys-libs/libraw1394[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-fix-config-load-crash.patch" )

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
		# This only works for JACK1>=0.122.0 or JACK2>=1.9.9.
		ENABLE_SETBUFFERSIZE_API_VER=force
		BUILD_MIXER=false # bug #965503
	)
	if multilib_is_native_abi; then
		myesconsargs+=( BUILD_TESTS=$(usex test-programs) )
	else
		myesconsargs+=( BUILD_TESTS=false )
	fi
	escons "${myesconsargs[@]}" "${@}"
}

src_prepare() {
	default

	# Bug #808853
	cp "${BROOT}"/usr/share/gnuconfig/config.guess admin/ || die "Failed to update config.guess"

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
}

pkg_postinst() {
	xdg_icon_cache_update
	udev_reload
}

pkg_postrm() {
	xdg_icon_cache_update
	udev_reload
}
