# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="intel-vaapi-driver"
if [[ ${PV} = *9999* ]] ; then # Live ebuild
	inherit git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="https://github.com/intel/intel-vaapi-driver"
fi
AUTOTOOLS_AUTORECONF="yes"
inherit autotools-multilib

DESCRIPTION="HW video decode support for Intel integrated graphics"
HOMEPAGE="https://github.com/intel/intel-vaapi-driver"
if [[ ${PV} != *9999* ]] ; then
	SRC_URI="https://github.com/intel/${MY_PN}/releases/download/${PV}/${MY_PN}-${PV}.tar.bz2"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0"
IUSE="wayland X"

RDEPEND="
	>=x11-libs/libdrm-2.4.52[video_cards_intel,${MULTILIB_USEDEP}]
	>=x11-libs/libva-2.4.0:=[X?,wayland?,drm,${MULTILIB_USEDEP}]
	wayland? (
		>=dev-libs/wayland-1.11[${MULTILIB_USEDEP}]
		>=media-libs/mesa-9.1.6[egl,${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS NEWS README )
AUTOTOOLS_PRUNE_LIBTOOL_FILES="all"

src_prepare() {
	sed -e 's/intel-gen4asm/\0diSaBlEd/g' -i configure.ac || die
	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable wayland)
		$(use_enable X x11)
	)
	autotools-utils_src_configure
}
