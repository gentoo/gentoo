# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/sekrit-twc/zimg"
	inherit git-r3
else
	SRC_URI="https://github.com/sekrit-twc/zimg/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"
	S="${WORKDIR}/${PN}-release-${PV}/"
fi
inherit autotools multilib-minimal

DESCRIPTION="Scaling, colorspace conversion, and dithering library"
HOMEPAGE="https://github.com/sekrit-twc/zimg"

LICENSE="WTFPL-2"
SLOT="0"
IUSE="cpu_flags_x86_sse"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		$(use_enable cpu_flags_x86_sse x86simd)
}
