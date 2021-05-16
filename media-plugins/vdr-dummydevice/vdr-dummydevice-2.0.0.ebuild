# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: dummy output device ,for recording server without any output devices"
HOMEPAGE="http://phivdr.dyndns.org/vdr/vdr-dummydevice/"
SRC_URI="http://phivdr.dyndns.org/vdr/${PN}/${P}.tgz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0.0"
