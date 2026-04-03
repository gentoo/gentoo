# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Tool to help manage 'well known' user directories"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xdg-user-dirs"
SRC_URI="https://user-dirs.freedesktop.org/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="gtk"

BDEPEND="app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	sys-devel/gettext"
PDEPEND="gtk? ( x11-misc/xdg-user-dirs-gtk )"

PATCHES=(
	"${FILESDIR}"/${P}-replace-shell-script-with-C-implementation.patch
)
