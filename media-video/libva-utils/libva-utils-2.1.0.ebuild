# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-r3
	EGIT_BRANCH=master
	EGIT_REPO_URI="https://github.com/intel/libva-utils"
fi

AUTOTOOLS_AUTORECONF="yes"
inherit autotools-utils ${SCM} multilib

DESCRIPTION="Collection of utilities and tests for VA-API"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
else
	SRC_URI="https://github.com/intel/libva-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="+drm test wayland X"

RDEPEND="
	>=x11-libs/libva-2.1.0:=[drm?,wayland?,X?]
	drm? ( >=x11-libs/libdrm-2.4 )
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libXfixes-5.0.1
	)
	wayland? ( >=dev-libs/wayland-1.0.6 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="|| ( drm wayland X )"

DOCS=( CONTRIBUTING.md README.md )

src_prepare() {
	sed -e 's/-Werror//' -i test/Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable X x11)
		$(use_enable wayland)
		$(use_enable drm)
		$(use_enable test tests)
	)
	autotools-utils_src_configure
}
