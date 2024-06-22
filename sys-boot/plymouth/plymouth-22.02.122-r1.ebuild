# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic
SRC_URI="https://dev.gentoo.org/~aidecoe/distfiles/${CATEGORY}/${PN}/gentoo-logo.png"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/plymouth/plymouth"
else
	SRC_URI="${SRC_URI} https://www.freedesktop.org/software/plymouth/releases/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ppc ppc64 ~riscv sparc x86"
fi

inherit autotools readme.gentoo-r1 systemd

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="https://cgit.freedesktop.org/plymouth/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug +drm +gtk +pango selinux +split-usr static-libs +udev"

CDEPEND="
	>=media-libs/libpng-1.2.16:=
	drm? ( x11-libs/libdrm )
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gtk+-3.14:3[X]
		x11-libs/cairo
	)
	pango? ( >=x11-libs/pango-1.21 )
"
DEPEND="${CDEPEND}
	elibc_musl? ( sys-libs/rpmatch-standalone )
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"
# Block due bug #383067
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-plymouthd )
	udev? ( virtual/udev )
	!<sys-kernel/dracut-0.37-r3
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	https://wiki.gentoo.org/wiki/Plymouth#Configuration
"

PATCHES=(
	"${FILESDIR}"/0.9.3-glibc-sysmacros.patch
	"${FILESDIR}"/${P}-glibc-2.36.patch
)

src_prepare() {
	use elibc_musl && append-ldflags -lrpmatch
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--with-system-root-install=no
		--localstatedir=/var
		--without-rhgb-compat-link
		--enable-documentation
		--enable-systemd-integration
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
		$(use_enable !static-libs shared)
		$(use_enable static-libs static)
		$(use_enable debug tracing)
		$(use_enable drm)
		$(use_enable gtk)
		$(use_enable pango)
		$(use_with udev)
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	insinto /usr/share/plymouth
	newins "${DISTDIR}"/gentoo-logo.png bizcom.png

	if use split-usr ; then
		# Install compatibility symlinks as some rdeps hardcode the paths
		dosym ../usr/bin/plymouth /bin/plymouth
		dosym ../usr/sbin/plymouth-set-default-theme /sbin/plymouth-set-default-theme
		dosym ../usr/sbin/plymouthd /sbin/plymouthd
	fi

	readme.gentoo_create_doc

	# looks like make install create /var/run/plymouth
	# this is not needed for systemd, same should hold for openrc
	# so remove
	rm -rf "${D}"/var/run

	# fix broken symlink
	dosym ../../bizcom.png /usr/share/plymouth/themes/spinfinity/header-image.png
}

pkg_postinst() {
	readme.gentoo_print_elog
	if ! has_version "sys-kernel/dracut"; then
		ewarn "If you want initramfs builder with plymouth support, please emerge"
		ewarn "sys-kernel/dracut."
	fi
}
