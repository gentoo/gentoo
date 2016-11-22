# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib-minimal

DESCRIPTION="AudioProcessing library from the webrtc.org code base"
HOMEPAGE="https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing/"
SRC_URI="https://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="static-libs"

DOCS=( AUTHORS NEWS README.md )

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf
}

multilib_src_install_all() {
	find "${D}" -type f \( -name "*.a" -o -name "*.la" \) -delete || die
}
