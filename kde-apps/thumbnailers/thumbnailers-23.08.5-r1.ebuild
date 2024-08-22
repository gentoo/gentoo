# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for KIO thumbnail generators"
HOMEPAGE="https://apps.kde.org/kdegraphics_thumbnailers/"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="blender mobi pdf raw"

RDEPEND="
	blender? ( >=media-gfx/kio-blender-thumbnailer-${PV}:5 )
	mobi? ( >=media-gfx/kio-mobi-thumbnailer-${PV}:5 )
	pdf? ( >=media-gfx/kio-ps-thumbnailer-${PV}:5 )
	raw? ( >=media-gfx/kio-raw-thumbnailer-${PV}:5 )
"
