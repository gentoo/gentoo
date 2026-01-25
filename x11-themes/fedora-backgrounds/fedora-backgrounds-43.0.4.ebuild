# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A set of default and supplemental wallpapers for Fedora"
HOMEPAGE="https://github.com/fedoradesign/backgrounds"

MY_PN="f$(ver_cut 1)-backgrounds"
MY_P="${MY_PN}-${PV}"
SRC_URI="https://github.com/fedoradesign/backgrounds/releases/download/v${PV}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

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
