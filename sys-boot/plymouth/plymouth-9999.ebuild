# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson readme.gentoo-r1 flag-o-matic

SRC_URI="https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/gentoo-logo.png"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/plymouth/plymouth"
else
	SRC_URI="${SRC_URI} https://www.freedesktop.org/software/plymouth/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="https://cgit.freedesktop.org/plymouth/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="debug +drm +gtk +pango selinux freetype +split-usr +udev doc systemd"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-libs/libxslt
	)
"

COMMON_DEPEND="
	dev-libs/libevdev
	>=media-libs/libpng-1.2.16:=
	x11-libs/libxkbcommon
	x11-misc/xkeyboard-config
	drm? ( x11-libs/libdrm )
	freetype? ( media-libs/freetype:2 )
	gtk? (
		dev-libs/glib:2
		x11-libs/cairo
		>=x11-libs/gtk+-3.14:3[X]
	)
	pango? (
		x11-libs/cairo
		>=x11-libs/pango-1.21
	)
	systemd? ( sys-apps/systemd )
	udev? ( virtual/libudev )
"

DEPEND="${COMMON_DEPEND}
	elibc_musl? ( sys-libs/rpmatch-standalone )
"

RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-plymouthd )
	udev? ( virtual/udev )
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	https://wiki.gentoo.org/wiki/Plymouth#Configuration
"

src_prepare() {
	use elibc_musl && append-ldflags -lrpmatch
	default
}

src_configure() {
	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		$(meson_feature gtk)
		$(meson_feature freetype)
		$(meson_feature pango)
		$(meson_feature udev)
		$(meson_use drm)
		$(meson_use systemd systemd-integration)
		$(meson_use doc docs)
		$(meson_use debug tracing)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	insinto /usr/share/plymouth

	newins "${DISTDIR}"/gentoo-logo.png bizcom.png
	# fix broken symlink
	dosym ../../bizcom.png /usr/share/plymouth/themes/spinfinity/header-image.png

	if use split-usr; then
		# Install compatibility symlinks as some rdeps hardcode the paths
		dosym ../usr/bin/plymouth /bin/plymouth
		dosym ../usr/sbin/plymouth-set-default-theme /sbin/plymouth-set-default-theme
		dosym ../usr/sbin/plymouthd /sbin/plymouthd
	fi

	# the file /var/spool/plymouth/boot.log is linked to the boot log after
	# booting when there are errors, there is no runtime check to create this
	# directory (the file is directly linked using unistd `link`) meaning there
	# may be missing logs or unexpected behaviour if it is not kept.
	keepdir /var/spool/plymouth
	# /var/lib/plymouth is created at runtime, and is used to store boot/shutdown
	# durations, it doesn't need to be created at build.
	rm -r "${ED}"/var/lib || die
	# /run/plymouth is also created at runtime
	rm -r "${ED}"/run || die

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version "sys-kernel/dracut"; then
		ewarn "dracut is not installed, if you wish to have an initramfs with"
		ewarn "plymouth support, you can emerge 'sys-kernel/dracut' otherwise"
		ewarn "you can look at the plymouth wiki for other methods:"
		ewarn "https://wiki.gentoo.org/wiki/Plymouth#Building_Initramfs"
	fi
}
