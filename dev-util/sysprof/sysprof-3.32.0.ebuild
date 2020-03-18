# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="System-wide Linux Profiler"
HOMEPAGE="http://sysprof.com/"

LICENSE="GPL-3+ GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="elogind gtk systemd"
REQUIRED_USE="?? ( elogind systemd )"

RDEPEND="
	>=dev-libs/glib-2.44:2
	sys-auth/polkit
	gtk? ( >=x11-libs/gtk+-3.22.0:3 )
	elogind? ( >=sys-auth/elogind-239.3 )
	systemd? ( >=sys-apps/systemd-222:0= )
"
DEPEND="${RDEPEND}"
# libxml2 required for glib-compile-resources; appstream-glib for appdata.xml developer_name tag translation
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	>=sys-kernel/linux-headers-2.6.32
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/3.30.2-elogind.patch )

src_configure() {
	# -Dwith_sysprofd=host currently unavailable from ebuild
	local emesonargs=(
		$(meson_use gtk enable_gtk)
		-Dwith_sysprofd=$(usex systemd bundled $(usex elogind bundled none))
		-Dsystemdunitdir=$(systemd_get_systemunitdir)
		# -Ddebugdir
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
	if ! use systemd && ! use elogind; then
		elog ""
		elog "Without systemd or elogind, sysprof may not function when launched as a"
		elog "regular user, thus suboptimal running from root account may be necessary."
		if use gtk; then
			elog "Under wayland, that limits the recording usage to sysprof-cli utility."
		fi
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
