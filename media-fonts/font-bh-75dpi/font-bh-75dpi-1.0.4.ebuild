# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
FONT_OPENTYPE_COMPAT=1
XORG_TARBALL_SUFFIX="xz"
XORG_PACKAGE_NAME="bh-75dpi"
inherit xorg-3

DESCRIPTION="X.Org Bigelow & Holmes bitmap fonts"

LICENSE="public-domain" # bitmap font, not copyrightable
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="nls"
