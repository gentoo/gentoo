# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils readme.gentoo systemd toolchain-funcs

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="https://cgit.freedesktop.org/plymouth/"
SRC_URI="
	https://www.freedesktop.org/software/plymouth/releases/${P}.tar.bz2
	https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/gentoo-logo.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE_VIDEO_CARDS="video_cards_intel video_cards_radeon"
IUSE="${IUSE_VIDEO_CARDS} debug gdm +gtk +libkms +pango static-libs"

CDEPEND="
	>=media-libs/libpng-1.2.16
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gtk+-2.12:2 )
	libkms? ( x11-libs/libdrm[libkms] )
	pango? ( >=x11-libs/pango-1.21 )
	video_cards_intel? ( x11-libs/libdrm[video_cards_intel] )
	video_cards_radeon? ( x11-libs/libdrm[video_cards_radeon] )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
# Block due bug #383067
RDEPEND="${CDEPEND}
	virtual/udev
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	https://dev.gentoo.org/~aidecoe/doc/en/plymouth.xml
"

PATCHES=(
	"${FILESDIR}/0.8.8-initrd-binaries-paths.patch"
)

src_prepare() {
	sed -i 's:/bin/systemd-tty-ask-password-agent:/usr/bin/systemd-tty-ask-password-agent:g' \
		systemd-units/systemd-ask-password-plymouth.service.in || die \
		'ask-password sed failed'
	sed -i 's:/bin/udevadm:/usr/bin/udevadm:g' \
		systemd-units/plymouth-start.service.in || die 'udevadm sed failed'
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-system-root-install=no
		--localstatedir=/var
		--without-rhgb-compat-link
		--enable-systemd-integration
		$(use_enable debug tracing)
		$(use_enable gtk gtk)
		$(use_enable libkms)
		$(use_enable pango)
		$(use_enable gdm gdm-transition)
		$(use_enable video_cards_intel libdrm_intel)
		$(use_enable video_cards_radeon libdrm_radeon)
		)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	insinto /usr/share/plymouth
	newins "${DISTDIR}"/gentoo-logo.png bizcom.png

	# Install compatibility symlinks as some rdeps hardcode the paths
	dosym /usr/bin/plymouth /bin/plymouth
	dosym /usr/sbin/plymouth-set-default-theme /sbin/plymouth-set-default-theme
	dosym /usr/sbin/plymouthd /sbin/plymouthd

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version "sys-kernel/dracut[dracut_modules_plymouth]" && ! has_version "sys-kernel/genkernel-next[plymouth]"; then
		ewarn "If you want initramfs builder with plymouth support, please emerge"
		ewarn "sys-kernel/dracut[dracut_modules_plymouth] or sys-kernel/genkernel-next[plymouth]."
	fi
}
