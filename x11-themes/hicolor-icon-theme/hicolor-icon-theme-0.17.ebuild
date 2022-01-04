# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils

DESCRIPTION="Fallback theme for the freedesktop icon theme specification"
HOMEPAGE="https://freedesktop.org/wiki/Software/icon-theme"
SRC_URI="https://icon-theme.freedesktop.org/releases/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

BDEPEND="app-arch/xz-utils"

RESTRICT="binchecks strip"

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
