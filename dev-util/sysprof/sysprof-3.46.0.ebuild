# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
API_VERSION="4"
SLOT="0/${API_VERSION}"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="gtk test +unwind"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.73.0:2
	gtk? (
		>=gui-libs/gtk-4.6:4
		gui-libs/libadwaita:1
		x11-libs/cairo
		x11-libs/pango
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
	sed -i \
			-e '/install: not meson.is_subproject/d' \
			-e '/install.*sysprof_header_subdir/d' \
			-e 's/pkgconfig\.generate/subdir_done()\npkgconfig\.generate/' \
			src/libsysprof-capture/meson.build || die
}

src_configure() {
	# -Dsysprofd=host currently unavailable from ebuild
	local emesonargs=(
		$(meson_use gtk)
		-Dlibsysprof=true
		-Dinstall-static=false
		-Dsysprofd=bundled
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
		-Dhelp=true
		$(meson_use unwind libunwind)
		-Dtools=true
		$(meson_use test tests)
		-Dexamples=false
		-Dagent=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# We want to ship org.gnome.Sysprof3.Profiler.xml in sysprof-common for the benefit of x11-wm/mutter
	rm "${ED}"/usr/share/dbus-1/interfaces/org.gnome.Sysprof3.Profiler.xml || die
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
