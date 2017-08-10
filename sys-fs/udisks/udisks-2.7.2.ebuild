# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools bash-completion-r1 eutils linux-info systemd udev xdg-utils

DESCRIPTION="Daemon providing interfaces to work with storage devices"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/udisks"
SRC_URI="https://github.com/storaged-project/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="acl cryptsetup debug elogind +gptfdisk +introspection lvm nls selinux systemd"

REQUIRED_USE="?? ( elogind systemd )"

COMMON_DEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libatasmart-0.19
	>=sys-auth/polkit-0.110
	sys-libs/libblockdev[lvm?]
	>=virtual/libgudev-165:=
	virtual/udev
	acl? ( virtual/acl )
	cryptsetup? ( sys-libs/libblockdev[crypt] )
	elogind? ( >=sys-auth/elogind-219 )
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	lvm? ( sys-fs/lvm2 )
	systemd? ( >=sys-apps/systemd-209 )
"
# gptfdisk -> src/udiskslinuxpartition.c -> sgdisk (see also #412801#c1)
# util-linux -> mount, umount, swapon, swapoff (see also #403073)
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/util-linux-2.20.1-r2
	>=sys-block/parted-3
	virtual/eject
	cryptsetup? (
		sys-fs/cryptsetup[udev(+)]
		sys-fs/lvm2[udev(+)]
	)
	gptfdisk? ( >=sys-apps/gptfdisk-0.8 )
	selinux? ( sec-policy/selinux-devicekit )
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.32
	>=dev-util/gtk-doc-1.3
	gnome-base/gnome-common:3
	sys-devel/autoconf-archive
	>=sys-kernel/linux-headers-3.1
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"

S="${WORKDIR}/${PN}-${P}"

QA_MULTILIB_PATHS="usr/lib/udisks2/udisksd"

DOCS=( AUTHORS HACKING NEWS README.md )

pkg_setup() {
	# Listing only major arch's here to avoid tracking kernel's defconfig
	if use amd64 || use arm || use ppc || use ppc64 || use x86; then
		CONFIG_CHECK="~!IDE" #319829
		CONFIG_CHECK+=" ~TMPFS_POSIX_ACL" #412377
		CONFIG_CHECK+=" ~SWAP" # https://forums.gentoo.org/viewtopic-t-923640.html
		CONFIG_CHECK+=" ~NLS_UTF8" #425562
		kernel_is lt 3 10 && CONFIG_CHECK+=" ~USB_SUSPEND" #331065, #477278
		linux-info_pkg_setup
	fi
}

src_prepare() {
	xdg_environment_reset

	default

	eautoreconf

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
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	prune_libtool_files
	keepdir /var/lib/udisks2 #383091

	rm -rf "${ED}"/usr/share/bash-completion
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
