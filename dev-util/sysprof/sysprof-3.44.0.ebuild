# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
API_VERSION="4"
SLOT="0/${API_VERSION}"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="gtk +unwind"

RDEPEND="
	>=dev-libs/glib-2.67.4:2
	gtk? (
		>=x11-libs/gtk+-3.22.0:3
		>=dev-libs/libdazzle-3.30.0
	)
	dev-libs/json-glib
	>=sys-auth/polkit-0.114
	unwind? ( sys-libs/libunwind:= )
	>=dev-util/sysprof-common-${PV}
	>=dev-util/sysprof-capture-${PV}:${API_VERSION}
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	>=sys-kernel/linux-headers-2.6.32
	virtual/pkgconfig
"

src_prepare() {
	default
	xdg_environment_reset
	# These are installed by dev-util/sysprof-capture
	sed -i -e '/install/d' src/libsysprof-capture/meson.build || die
	sed -i -e 's/pkgconfig\.generate/subdir_done()\npkgconfig\.generate/' src/libsysprof-capture/meson.build || die
	# We want to ship org.gnome.Sysprof3.Profiler.xml in sysprof-common for the benefit of x11-wm/mutter
	sed -i -e "s|if get_option('libsysprof')|if false|g" src/meson.build || die
}

src_configure() {
	# -Dwith_sysprofd=host currently unavailable from ebuild
	local emesonargs=(
		$(meson_use gtk enable_gtk)
		-Dlibsysprof=true
		-Dwith_sysprofd=bundled
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
		-Dhelp=true
		$(meson_use unwind libunwind)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	elog "On many systems, especially amd64, it is typical that with a modern"
	elog "toolchain -fomit-frame-pointer for gcc is the default, because"
	elog "debugging is still possible thanks to gcc4/gdb location list feature."
	elog "However sysprof is not able to construct call trees if frame pointers"
	elog "are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested"
	elog "for the libraries and applications involved in the profiling. That"
	elog "means a CPU register is used for the frame pointer instead of other"
	elog "purposes, which means a very minimal performance loss when there is"
	elog "register pressure."
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
