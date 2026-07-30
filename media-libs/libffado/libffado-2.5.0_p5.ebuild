# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit desktop python-single-r1 scons-utils toolchain-funcs udev xdg multilib-minimal

DESCRIPTION="Driver for IEEE1394 (Firewire) audio interfaces"
HOMEPAGE="https://ffado.org/"
if [[ ${PV} == *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="http://subversion.ffado.org/ffado/trunk/${PN}"
else
	SRC_URI="
		https://ffado.org/files/${PN}-${PV%_p*}.tgz
		mirror://debian/pool/main/libf/libffado/${PN}_${PV/_p/-}.debian.tar.xz
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${PN}-${PV%_p*}"
fi

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="debug gui test-programs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	>=dev-libs/dbus-c++-0.9.0-r5
	virtual/pkgconfig
	$(python_gen_cond_dep 'dev-python/setuptools[${PYTHON_USEDEP}]')
"
RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/dbus-c++-0.9.0-r5
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/libconfig:=[cxx,${MULTILIB_USEDEP}]
	media-libs/alsa-lib
	media-libs/libiec61883[${MULTILIB_USEDEP}]
	sys-apps/dbus
	sys-libs/libraw1394[${MULTILIB_USEDEP}]
	gui? (
		$(python_gen_cond_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/qtpy[dbus,gui,pyqt6,widgets,${PYTHON_USEDEP}]
		')
		x11-misc/xdg-utils
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	# missing includes for expat
	"${WORKDIR}"/debian/patches/0002-Include-config.h.patch
	# qtpy/PyQt6 port
	"${WORKDIR}"/debian/patches/0003-Replace-PyQt4-with-PyQt6.patch

	# use shutil.which instead of sys-apps/which
	"${FILESDIR}"/${PN}-2.5.0-use_shutil_which.patch
	# first try PKG_CONFIG from env
	"${FILESDIR}"/${PN}-2.5.0-fix_pkgconfig.patch
	# fix clang
	"${FILESDIR}"/${PN}-2.5.0-fix_literal_concat.patch
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
		# unused and will show a wrong target w/ cross-compile
		DIST_TARGET=none
		PYPKGDIR="$(python_get_sitedir)"
		PYTHON_INTERPRETER="${PYTHON}"
		# use dev-libs/expat instead of dev-cpp/libxmlpp
		SERIALIZE_USE_EXPAT=true
		# ENABLE_OPTIMIZATIONS detects cpu type and sets flags accordingly
		# -fomit-frame-pointer is added also which can cripple debugging.
		# we set flags from portage instead
		ENABLE_OPTIMIZATIONS=false
		# This only works for JACK1>=0.122.0 or JACK2>=1.9.9.
		ENABLE_SETBUFFERSIZE_API_VER=force
	)
	if multilib_is_native_abi; then
		myesconsargs+=(
			BUILD_MIXER=$(usex gui true false)
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

	# Bug #808853
	cp "${BROOT}"/usr/share/gnuconfig/config.guess admin/ || die "Failed to update config.guess"

	# Bugs #658052, #659226
	sed -i -e 's/^CacheDir/#CacheDir/' SConstruct || die

	# skip CompilerCheck with TryRun
	if tc-is-cross-compiler; then
		sed -e '/"CompilerCheck" :/s/: CompilerCheck,/: lambda context: (context.Message("Checking C-compiler... "), context.Result("skipped")) and True,/' \
			-i SConstruct || die
	fi

	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CC CXX PKG_CONFIG
	myescons
}

multilib_src_install() {
	myescons DESTDIR="${D}" WILL_DEAL_WITH_XDG_MYSELF="True" install
}

multilib_src_install_all() {
	einstalldocs

	python_fix_shebang "${D}"
	python_optimize "${D}"

	if use gui; then
		newicon "support/xdg/hi64-apps-ffado.png" "ffado.png"
		newmenu "support/xdg/org.ffado.FfadoMixer.desktop" "ffado-mixer.desktop"
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
	udev_reload
}

pkg_postrm() {
	xdg_icon_cache_update
	udev_reload
}
