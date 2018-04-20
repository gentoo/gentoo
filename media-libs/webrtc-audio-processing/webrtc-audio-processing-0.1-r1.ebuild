# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
inherit autotools-multilib

DESCRIPTION="AudioProcessing library from the webrtc.org code base"
HOMEPAGE="https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="static-libs"

RDEPEND=""

DOCS=( AUTHORS NEWS README )
