# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: dummy output device ,for recording server without any output devices"
HOMEPAGE="https://phivdr.dyndns.org/vdr/vdr-dummydevice/"
SRC_URI="https://phivdr.dyndns.org/vdr/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"
