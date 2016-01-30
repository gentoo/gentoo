# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes

SCM=""

if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/sekrit-twc/zimg"
fi

inherit autotools-multilib ${SCM}

DESCRIPTION="Scaling, colorspace conversion, and dithering library"
HOMEPAGE="https://github.com/sekrit-twc/zimg"

if [ "${PV#9999}" = "${PV}" ] ; then
	SRC_URI="https://github.com/sekrit-twc/zimg/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-release-${PV}/"
fi

LICENSE="WTFPL-2"
SLOT="0"
IUSE="static-libs cpu_flags_x86_sse"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	autotools-multilib_src_configure \
		$(use_enable cpu_flags_x86_sse x86simd)
}
