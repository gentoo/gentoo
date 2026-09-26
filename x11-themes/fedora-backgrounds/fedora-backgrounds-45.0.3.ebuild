# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="A set of default and supplemental wallpapers for Fedora"
HOMEPAGE="https://forge.fedoraproject.org/design/backgrounds"
SRC_URI="https://forge.fedoraproject.org/design/backgrounds/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/backgrounds"

# Review on each bump, files Attribution*
LICENSE="CC-BY-SA-4.0"

SLOT="$(ver_cut 1)"

KEYWORDS="~amd64 ~x86"

# Migrate to virtual/imagemagick-tools when it supports jpegxl:
# https://bugs.gentoo.org/953960
BDEPEND="|| (
		media-gfx/imagemagick[jpegxl(-),png]
		media-gfx/graphicsmagick[imagemagick,jpegxl,png]
	)
"
