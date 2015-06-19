# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/startup-notification/startup-notification-0.12-r1.ebuild,v 1.11 2015/05/27 12:40:22 zlogene Exp $

EAPI=5
inherit eutils xorg-2

DESCRIPTION="Application startup notification and feedback library"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/startup-notification"
SRC_URI="http://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2 MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=x11-libs/libX11-1.4.3
	>x11-libs/libxcb-1.6
	>=x11-libs/xcb-util-0.3.8"
DEPEND="${RDEPEND}
	x11-proto/xproto"

DOCS=( AUTHORS ChangeLog NEWS doc/${PN}.txt )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-sys-select_h.patch \
		"${FILESDIR}"/${P}-time_t-crash-with-32bit.patch
	elibtoolize
}
