# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

MY_P="msamr-${PV}"

DESCRIPTION="mediastreamer plugin: add AMR Narrow Band support"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="mirror://nongnu/linphone/plugins/sources/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=media-libs/mediastreamer-2.0.0:=
	>=media-libs/opencore-amr-0.1.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-include.patch"
}

src_configure() {
	# strict: don't want -Werror
	econf \
		--disable-strict
}
