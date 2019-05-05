# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools-multilib

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/libbdplus.git"
else
	SRC_URI="https://downloads.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"
	KEYWORDS="amd64 ppc ppc64 sparc x86"
fi

DESCRIPTION="Blu-ray library for BD+ decryption"
HOMEPAGE="https://www.videolan.org/developers/libbdplus.html"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="aacs static-libs"

RDEPEND="dev-libs/libgcrypt:0=[${MULTILIB_USEDEP}]
	dev-libs/libgpg-error[${MULTILIB_USEDEP}]
	aacs? ( >=media-libs/libaacs-0.7.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

DOCS="ChangeLog README.txt"

src_configure() {
	local myeconfargs=(
		--disable-optimizations
		$(use_with aacs libaacs)
	)
	autotools-multilib_src_configure
}
