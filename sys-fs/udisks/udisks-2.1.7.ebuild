# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit bash-completion-r1 eutils linux-info systemd udev

DESCRIPTION="Daemon providing interfaces to work with storage devices"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/udisks"
SRC_URI="https://udisks.freedesktop.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 ~ia64 ~mips ppc ~ppc64 ~sh ~sparc x86"
IUSE="acl debug cryptsetup +gptfdisk +introspection selinux systemd"

COMMON_DEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libatasmart-0.19
	>=sys-auth/polkit-0.110
	>=virtual/libgudev-165:=
	virtual/udev
	acl? ( virtual/acl )
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
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
	>=dev-util/gtk-doc-am-1.3
	dev-util/intltool
	>=sys-kernel/linux-headers-3.1
	virtual/pkgconfig
"

QA_MULTILIB_PATHS="usr/lib/udisks2/udisksd"

DOCS="AUTHORS HACKING NEWS README"

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
	use systemd || { sed -i -e 's:libsystemd-login:&disable:' configure || die; }
	epatch "${FILESDIR}"/${PN}-2.1.7-sysmacros.patch #580230

	epatch_user
}

src_configure() {
	econf \
		--localstatedir="${EPREFIX}"/var \
		--disable-static \
		$(use_enable acl) \
		$(use_enable debug) \
		--disable-gtk-doc \
		$(use_enable introspection) \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--with-udevdir="$(get_udevdir)" \
		"$(systemd_with_unitdir)"
}

src_install() {
	default
	prune_libtool_files
	keepdir /var/lib/udisks2 #383091

	rm -rf "${ED}"/usr/share/bash-completion
	dobashcomp data/completions/udisksctl

	local htmldir=udisks2
	if [[ -d ${ED}/usr/share/doc/${PF}/html/${htmldir} ]]; then
		dosym /usr/share/doc/${PF}/html/${htmldir} /usr/share/gtk-doc/html/${htmldir}
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
