# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="create a shadow directory of symbolic links to another directory tree"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	elibc_glibc? (
		|| ( >=sys-libs/glibc-2.38 dev-libs/libbsd )
	)
	!elibc_glibc? (
		dev-libs/libbsd
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
