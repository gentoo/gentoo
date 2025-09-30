# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils greadme meson systemd xdg

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="https://www.sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
API_VERSION="4"
SLOT="0/${API_VERSION}"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"
IUSE="gtk llvm-libunwind systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.76.0:2
	gtk? (
		>=gui-libs/gtk-4.15:4
		>=gui-libs/libadwaita-1.6.0:1
		x11-libs/cairo
		x11-libs/pango
	)
	systemd? ( sys-apps/systemd )
	dev-libs/json-glib
	>=dev-libs/libdex-0.9
	>=gui-libs/libpanel-1.4
	|| (
		llvm-libunwind? ( llvm-runtimes/libunwind )
		!llvm-libunwind? ( sys-libs/libunwind )
	)
	>=sys-auth/polkit-0.114[daemon(+)]
	dev-libs/elfutils
	>=dev-util/sysprof-common-${PV}
	>=dev-util/sysprof-capture-${PV}:${API_VERSION}
"
DEPEND="
	${RDEPEND}
	!systemd? ( !!sys-apps/systemd )
"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	>=sys-kernel/linux-headers-2.6.32
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-48.0-shadowed-variable.patch
)

src_prepare() {
	xdg_environment_reset

	# These are installed by dev-util/sysprof-capture
	sed -i \
			-e '/install: not meson.is_subproject/d' \
			-e '/install.*sysprof_header_subdir/d' \
			-e 's/pkgconfig\.generate/subdir_done()\npkgconfig\.generate/' \
			src/libsysprof-capture/meson.build || die

	if use llvm-libunwind ; then
		PATCHES+=( "${FILESDIR}"/${PN}-llvm-libunwind-fix.patch )
	fi
	default
}

src_configure() {
	# similar to samba bug #874633
	if use llvm-libunwind ; then
		mkdir -p "${T}"/${ABI}/pkgconfig || die

		local -x PKG_CONFIG_PATH="${T}/${ABI}/pkgconfig:${PKG_CONFIG_PATH}"

		cat <<-EOF > "${T}"/${ABI}/pkgconfig/libunwind-generic.pc || die

		Name: libunwind-generic
		Description: libunwind generic library
		Version: 1.70
		Libs: -L/usr/\$(get_libdir) -lunwind
		EOF
	fi

	# -Dsysprofd=host currently unavailable from ebuild
	local emesonargs=(
		$(meson_use gtk)
		-Dlibsysprof=true
		-Dinstall-static=false
		-Dsysprofd=bundled
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
		-Dhelp=true
		-Dtools=true
		$(meson_use test tests)
		-Dexamples=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# We want to ship org.gnome.Sysprof3.Profiler.xml in sysprof-common for the benefit of x11-wm/mutter
	rm "${ED}"/usr/share/dbus-1/interfaces/org.gnome.Sysprof3.Profiler.xml || die

	greadme_stdin <<-EOF
	On many systems, especially amd64, it is typical that with a modern
	toolchain -fomit-frame-pointer for gcc is the default, because
	debugging is still possible thanks to gcc/gdb location list feature.
	However sysprof is not able to construct call trees if frame pointers
	are not present. Therefore -fno-omit-frame-pointer CFLAGS is suggested
	for the libraries and applications involved in the profiling. That
	means a CPU register is used for the frame pointer instead of other
	purposes, which means a very minimal performance loss when there is
	register pressure.
EOF
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
	greadme_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	greadme_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
