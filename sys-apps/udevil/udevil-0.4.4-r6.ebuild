# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info optfeature

DESCRIPTION="Mount and unmount removable devices without a password"
HOMEPAGE="https://ignorantguru.github.io/udevil/"
SRC_URI="https://github.com/IgnorantGuru/udevil/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	acct-group/plugdev
	>=app-shells/bash-4.0:*
	dev-libs/glib:2
	sys-apps/util-linux
	virtual/acl
	>=virtual/udev-143"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	# This works for 0.4.4 too, no sense copying the patch
	"${FILESDIR}"/${PN}-0.4.3-flags.patch
	"${FILESDIR}"/${PN}-0.4.4-stat.patch
	"${FILESDIR}"/${PN}-0.4.4-include-sysmacros.patch
	"${FILESDIR}"/${PN}-0.4.4-no-libtool.patch
	"${FILESDIR}"/${PN}-0.4.4-no-conf.d.patch
	"${FILESDIR}"/${PN}-0.4.4-include-sysstat.patch
	"${FILESDIR}"/${PN}-0.4.4-remove-exfat-options.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-setfacl-prog="$(type -P setfacl)" \
		--enable-systemd
}

src_install() {
	default
	fowners root:plugdev /usr/bin/udevil
	fperms 4754 /usr/bin/udevil
}

pkg_postinst() {
	einfo
	elog "Please add your user to the plugdev group"
	elog "to be able to use ${PN} as a user"
	elog
	optfeature_header "Optional dependencies:"
	optfeature "Devmon popups" "gnome-extra/zenity"
	optfeature "Mounting WebDAV resources" "net-fs/davfs2"
	optfeature "Mounting Samba shares" "net-fs/cifs-utils"
	optfeature "Mounting FTP shares" "net-fs/curlftpfs"
	optfeature "Mounting NFS shares" "net-fs/nfs-utils"
	optfeature "Mounting SFTP shares" "net-fs/sshfs"
	if ! has_version 'sys-fs/udisks' ; then
		elog
		elog "When using ${PN} without udisks, and without the udisks-daemon running,"
		elog "you may need to enable kernel polling for device media changes to be detected."
		elog "See https://ignorantguru.github.com/${PN}/#polling"
		has_version '<virtual/udev-173' && ewarn "You need at least udev-173"
		kernel_is lt 2 6 38 && ewarn "You need at least kernel 2.6.38"
		einfo
	fi
}
