# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="A library implementing the EBU R128 loudness standard."
HOMEPAGE="https://github.com/jiixyj/libebur128"
SRC_URI="https://github.com/jiixyj/libebur128/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+speex"

DEPEND="speex? ( media-libs/speex )"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=( $(cmake-utils_use_disable speex SPEEXDSP) )
	cmake-utils_src_configure
}
