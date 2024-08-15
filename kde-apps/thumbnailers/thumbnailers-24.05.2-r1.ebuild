# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for KIO thumbnail generators"
HOMEPAGE="https://apps.kde.org/kdegraphics_thumbnailers/"

LICENSE="metapackage"
SLOT="6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="blender mobi pdf raw" # video

RDEPEND="
	blender? ( >=media-gfx/kio-blender-thumbnailer-${PV}:6 )
	mobi? ( >=media-gfx/kio-mobi-thumbnailer-${PV}:6 )
	pdf? ( >=media-gfx/kio-ps-thumbnailer-${PV}:6 )
	raw? ( >=media-gfx/kio-raw-thumbnailer-${PV}:6 )
"
#	video? ( >=kde-apps/ffmpegthumbs-${PV}:6 )
