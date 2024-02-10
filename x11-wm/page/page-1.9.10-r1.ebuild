# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A mouse friendly tiling window manager"
HOMEPAGE="https://github.com/gschwind/page"
SRC_URI="https://github.com/gschwind/page/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=x11-libs/libxcb-1.11
	>=x11-libs/xcb-util-0.4.0
	>=x11-libs/libXfixes-5.0.3
	>=x11-libs/libXdamage-1.1.4-r1
	>=x11-libs/libXrandr-1.5.1
	>=x11-libs/libXcomposite-0.4.4-r1
	>=x11-libs/libXrender-0.9.10
	>=x11-libs/libXext-1.3.3
	>=x11-libs/cairo-1.14.6[X]
	>=x11-libs/pango-1.40.5
	>=dev-libs/glib-2.50.3-r1:2"
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.12-r2
	x11-base/xorg-proto"

src_install() {
	default

	# Solves file collision with dev-tcltk/tcllib, bug #574074
	ebegin "Changing references from 'page' to 'pagewm'"
	mv "${ED}"/usr/bin/page "${ED}"/usr/bin/pagewm || die "Could not rename binary!"
	sed -i -e "s:/usr/bin/page:/usr/bin/pagewm:" "${ED}"/usr/share/applications/page.desktop || die "Could not change .desktop file!"
	eend $?
}

pkg_postinst() {
	elog "page can now be launched using \"pagewm\". To find out more about this functionality,"
	elog "see the following bug report: https://bugs.gentoo.org/574074."
}
