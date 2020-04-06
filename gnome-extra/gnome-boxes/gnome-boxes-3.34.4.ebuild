# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.40"

inherit gnome.org gnome2-utils linux-info meson readme.gentoo-r1 vala xdg

DESCRIPTION="Simple GNOME 3 application to access remote or virtual systems"
HOMEPAGE="https://wiki.gnome.org/Apps/Boxes"

LICENSE="LGPL-2+ CC-BY-2.0"
SLOT="0"

IUSE="rdp"
KEYWORDS="~amd64"

# FIXME: qemu probably needs to depend on spice[smartcard] directly with USE=spice
# FIXME: Check over libvirt USE=libvirtd,qemu and the smartcard/usbredir requirements
# Technically vala itself still ships a libsoup vapi, but that may change, and it should be better to use the .vapi from the same libsoup version
# gtk-vnc raised due to missing vala bindings in earlier ebuilds
DEPEND="
	>=app-arch/libarchive-3.0.0:=
	>=dev-libs/glib-2.52:2
	>=x11-libs/gtk+-3.22.20:3
	>=net-libs/gtk-vnc-0.8.0-r1[gtk3(+)]
	>=sys-libs/libosinfo-1.4.0
	app-crypt/libsecret
	>=net-libs/libsoup-2.44:2.4
	virtual/libusb:1
	>=app-emulation/libvirt-glib-2.0.0
	>=dev-libs/libxml2-2.7.8:2
	>=net-misc/spice-gtk-0.32[gtk3(+),smartcard,usbredir]
	app-misc/tracker:0/2.0
	>=x11-libs/vte-0.40.2:2.91
	net-libs/webkit-gtk:4

	>=dev-libs/gobject-introspection-1.56:=
	>=dev-libs/libgudev-165:=
	rdp? ( net-misc/freerdp:= )
" # gobject-introspection needed for libovf subproject (and gtk-frdp subproject with USE=rdp)
# These are called via exec():
# sys-fs/mtools mcopy for unattended file copying for files that libarchive doesn't support
# virtual/cdrtools mkisofs is needed for unattended installer secondary disk image creation
# app-emulation/libguestfs virt-sysprep is used for VM cloing, if not there, it logs debug and doesn't function
# sys-apps/policycoreutils restorecon is used for checking selinux context
# app-emulation/libvirt virsh used for various checks (and we need the library anyways)
# sys-auth/polkit used for making all libvirt system disks readable via "pkexec chmod a+r" that aren't already readable to the user (libvirt system importer)
# app-emulation/qemu qemu-img used to convert image to QCOW2 format during copy
RDEPEND="${DEPEND}
	>=app-misc/tracker-miners-2[iso]
	app-emulation/spice[smartcard]
	>=app-emulation/libvirt-0.9.3[libvirtd,qemu]
	>=app-emulation/qemu-1.3.1[spice,smartcard,usbredir]
	sys-fs/mtools
	virtual/cdrtools
	sys-auth/polkit
"
# gtk-frdp generates gir and needs gtk+ introspection for it
# This is only needed for creating the .vapi file, but gnome-boxes needs it
BDEPEND="
	$(vala_depend)
	net-libs/gtk-vnc[vala]
	sys-libs/libosinfo[vala]
	app-crypt/libsecret[vala]
	net-libs/libsoup:2.4[vala]
	app-emulation/libvirt-glib[vala]
	net-misc/spice-gtk[vala]
	x11-libs/vte:2.91[vala]
	dev-libs/appstream-glib
	rdp? ( x11-libs/gtk+:3[introspection] )
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Before running gnome-boxes for local VMs, you will need to load the KVM modules.
If you have an Intel Processor, run:
# modprobe kvm-intel

If you have an AMD Processor, run:
# modprobe kvm-amd"

pkg_pretend() {
	linux-info_get_any_version

	if linux_config_exists; then
		if ! { linux_chkconfig_present KVM_AMD || \
			linux_chkconfig_present KVM_INTEL; }; then
			ewarn "You need KVM support in your kernel to use GNOME Boxes local VM support!"
		fi
	fi
}

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Ddistributor_name=Gentoo
		-Ddistributor_version=${PVR}
		$(meson_use rdp)
		-Dinstalled_tests=false
		-Dflatpak=false
		-Dprofile=default
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
