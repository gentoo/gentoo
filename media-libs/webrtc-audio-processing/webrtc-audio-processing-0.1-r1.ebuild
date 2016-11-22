# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r1
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"

DOCS=( AUTHORS NEWS README )
