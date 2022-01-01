# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xorg-3

DESCRIPTION="Application startup notification and feedback library"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/startup-notification"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

LICENSE="LGPL-2 MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=x11-libs/libX11-1.4.3
	>x11-libs/libxcb-1.6
	>=x11-libs/xcb-util-0.3.8"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( AUTHORS ChangeLog NEWS doc/${PN}.txt )

PATCHES=(
	"${FILESDIR}"/${P}-sys-select_h.patch
	"${FILESDIR}"/${P}-time_t-crash-with-32bit.patch
)
