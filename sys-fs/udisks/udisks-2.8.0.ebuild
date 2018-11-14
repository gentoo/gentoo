# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit bash-completion-r1 linux-info systemd udev xdg-utils

DESCRIPTION="Daemon providing interfaces to work with storage devices"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/udisks"
SRC_URI="https://github.com/storaged-project/udisks/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="acl debug elogind +introspection lvm nls selinux systemd vdo"

REQUIRED_USE="?? ( elogind systemd )"

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	>=dev-libs/libatasmart-0.19
	>=sys-auth/polkit-0.110
	>=sys-libs/libblockdev-2.19[cryptsetup,lvm?,vdo?]
	>=virtual/libgudev-165:=
	virtual/udev
	acl? ( virtual/acl )
	elogind? ( >=sys-auth/elogind-219 )
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	lvm? ( sys-fs/lvm2 )
	systemd? ( >=sys-apps/systemd-209 )
"
# util-linux -> mount, umount, swapon, swapoff (see also #403073)
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/util-linux-2.30
	>=sys-block/parted-3
	virtual/eject
	selinux? ( sec-policy/selinux-devicekit )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.32
	>=dev-util/gtk-doc-am-1.3
	>=sys-kernel/linux-headers-3.1
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"
# If adding a eautoreconf, then these might be needed at buildtime:
# dev-libs/gobject-introspection-common
# gnome-base/gnome-common:3
# sys-devel/autoconf-archive

DOCS=( AUTHORS HACKING NEWS README.md )

pkg_setup() {
	# Listing only major arch's here to avoid tracking kernel's defconfig
	if use amd64 || use arm || use ppc || use ppc64 || use x86; then
		CONFIG_CHECK="~!IDE" #319829
		CONFIG_CHECK+=" ~TMPFS_POSIX_ACL" #412377
		CONFIG_CHECK+=" ~NLS_UTF8" #425562
		kernel_is lt 3 10 && CONFIG_CHECK+=" ~USB_SUSPEND" #331065, #477278
		linux-info_pkg_setup
	fi
}

src_prepare() {
	xdg_environment_reset

	default

	if ! use systemd ; then
		sed -i -e 's:libsystemd-login:&disable:' configure || die
	fi
}

src_configure() {
	local myeconfargs=(
		--enable-btrfs
		--disable-gtk-doc
		--disable-static
		--localstatedir="${EPREFIX%/}"/var
		--with-html-dir="${EPREFIX%/}"/usr/share/gtk-doc/html
		--with-modprobedir="${EPREFIX%/}"/lib/modprobe.d
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-udevdir="$(get_udevdir)"
		$(use_enable acl)
		$(use_enable debug)
		$(use_enable introspection)
		$(use_enable lvm lvm2)
		$(use_enable lvm lvmcache)
		$(use_enable nls)
		$(use_enable vdo)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
	keepdir /var/lib/udisks2 #383091

	rm -rf "${ED%/}"/usr/share/bash-completion
	dobashcomp data/completions/udisksctl
}

pkg_preinst() {
	# Remove gtk-doc symlink, #597628
	if [[ -L "${EROOT}"/usr/share/gtk-doc/html/udisks2 ]]; then
		rm "${EROOT}"/usr/share/gtk-doc/html/udisks2 || die
	fi
}

pkg_postinst() {
	mkdir -p "${EROOT}"/run #415987

	# See pkg_postinst() of >=sys-apps/baselayout-2.1-r1. Keep in sync?
	if ! grep -qs "^tmpfs.*/run " "${EROOT}"/proc/mounts ; then
		echo
		ewarn "You should reboot the system now to get /run mounted with tmpfs!"
	fi
}
