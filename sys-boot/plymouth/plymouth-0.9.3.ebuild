# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI="https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/gentoo-logo.png"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/plymouth"
	inherit git-r3
else
	SRC_URI="${SRC_URI} https://www.freedesktop.org/software/plymouth/releases/${P}.tar.xz"
fi

inherit autotools readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="https://cgit.freedesktop.org/plymouth/"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug gdm +gtk +libkms +pango static-libs"

CDEPEND="
	>=media-libs/libpng-1.2.16:=
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gtk+-3.14:3
		x11-libs/cairo )
	libkms? ( x11-libs/libdrm[libkms] )
	pango? ( >=x11-libs/pango-1.21 )
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"
# Block due bug #383067
RDEPEND="${CDEPEND}
	virtual/udev
	!<sys-kernel/dracut-0.37-r3
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	https://wiki.gentoo.org/wiki/Plymouth#Configuration
"

PATCHES=(
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--with-system-root-install=no
		--localstatedir=/var
		--without-rhgb-compat-link
		--enable-systemd-integration
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
		$(use_enable !static-libs shared)
		$(use_enable static-libs static)
		$(use_enable debug tracing)
		$(use_enable gtk gtk)
		$(use_enable libkms drm)
		$(use_enable pango)
		$(use_enable gdm gdm-transition)
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	insinto /usr/share/plymouth
	newins "${DISTDIR}"/gentoo-logo.png bizcom.png

	# Install compatibility symlinks as some rdeps hardcode the paths
	dosym /usr/bin/plymouth /bin/plymouth
	dosym /usr/sbin/plymouth-set-default-theme /sbin/plymouth-set-default-theme
	dosym /usr/sbin/plymouthd /sbin/plymouthd

	readme.gentoo_create_doc

	# looks like make install create /var/run/plymouth
	# this is not needed for systemd, same should hold for openrc
	# so remove
	rm -rf "${D}"/var/run
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version "sys-kernel/dracut" && ! has_version "sys-kernel/genkernel-next[plymouth]"; then
		ewarn "If you want initramfs builder with plymouth support, please emerge"
		ewarn "sys-kernel/dracut or sys-kernel/genkernel-next[plymouth]."
	fi
}
