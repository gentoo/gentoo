# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{3_1,3_2,3_3,3_4,3_5,3_6} )
[[ "${PV}" == *9999 ]] && inherit subversion
inherit subversion
inherit eutils python-single-r1 scons-utils toolchain-funcs udev multilib-minimal

DESCRIPTION="Successor for freebob: Library for accessing BeBoB IEEE1394 devices"
HOMEPAGE="http://www.ffado.org"

RESTRICT="mirror"
if [[ "${PV}" = 2.9999 ]]; then
    ESVN_REPO_URI="http://subversion.ffado.org/ffado/trunk/${PN}"
    KEYWORDS="~arm ~arm64 ~ia64 ~ppc ~ppc64"
else
if [[ "${PV}" = *9999 ]]; then
    ESVN_REPO_URI="http://subversion.ffado.org/ffado/branches/${PV/9999/x}/${PN}"
    KEYWORDS="~arm ~arm64 ~ia64 ~ppc ~ppc64"
else
    SRC_URI="http://www.ffado.org/files/${P}.tgz"
    KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64"
fi
fi
#PATCHES=(libffado-2.3.9999-fix-python-3.patch libffado-2.3.9999-libxml3.0.patch libffado-2.3.9999-fix-gcc_warning.patch libffado-2.3.9999-gcc_auto_ptr.patch)
PATCHES=(libffado-2.3.9999-svn2723_compile_failed.patch)
LICENSE="GPL-2"
SLOT="0"
IUSE="debug optimize qt5 expat +test-programs"

RDEPEND="dev-cpp/libxmlpp[${MULTILIB_USEDEP}]
	dev-libs/dbus-c++
	dev-libs/libconfig[cxx,${MULTILIB_USEDEP}]
	media-libs/alsa-lib
	media-libs/libiec61883[${MULTILIB_USEDEP}]
	|| ( media-sound/jack2[${MULTILIB_USEDEP}] media-sound/jack-audio-connection-kit[${MULTILIB_USEDEP}] )
	sys-apps/dbus
	sys-libs/libraw1394[${MULTILIB_USEDEP}]
	sys-libs/libavc1394[${MULTILIB_USEDEP}]
	${PYTHON_DEPS}
	qt5? (
		dev-python/PyQt5[dbus,${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		x11-misc/xdg-utils
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

multilib_native_use_scons() {
	if multilib_is_native_abi; then
		use_scons "${@}"
	else
                    #BUILD_MIXER:qt4=false=false
		echo "${2:-${1}}=${4:-${USE_SCONS_FALSE}}"
	fi
}

myescons() {
        local mixer="false"
        if use qt5; then
		mixer="true"
        fi
        python_get_sitedir
	myesconsargs=(
		PREFIX="${EPREFIX}/usr"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"
		UDEVDIR="$(get_udevdir)/rules.d"
		CUSTOM_ENV=True
		DETECT_USERSPACE_ENV=False
		$(use_scons debug DEBUG)
		$(use_scons optimize ENABLE_OPTIMIZATIONS)
		$(use_scons expat SERIALIZE_USE_EXPAT)
		BUILD_MIXER="${mixer}"
		PYPKGDIR="${PYTHON_SITEDIR}"
		$(multilib_native_use_scons test-programs BUILD_TESTS)
		
	)
	escons "${@}"
}

src_unpack() {
	if [[ "${PV}" = *9999 ]]; then
		subversion_src_unpack
	else
		default
	fi
}

src_prepare() {
	[[ ${PATCHES[@]} ]] && EPATCH_SOURCE="${FILESDIR}" epatch "${PATCHES[@]}"
        if use qt5; then
            #epatch "${FILESDIR}/${P}-qt5.patch"
            cp ${FILESDIR}/*.png ${WORKDIR}/${P}/support/mixer-qt4/ffado/mixer/
        fi
	multilib_copy_sources	
}

multilib_src_configure() {
	: # no-op
}

multilib_src_compile () {
	tc-export CC CXX
	myescons
}

multilib_src_install () {
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
