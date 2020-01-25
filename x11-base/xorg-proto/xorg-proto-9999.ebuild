# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/xorg-/xorg}"
MY_P="${MY_PN}-${PV}"

EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/proto/${MY_PN}.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} meson

DESCRIPTION="X.Org combined protocol headers"
HOMEPAGE="https://gitlab.freedesktop.org/xorg/proto/xorgproto"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
	SRC_URI="https://xorg.freedesktop.org/archive/individual/proto/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	!<x11-proto/bigreqsproto-1.1.2-r1
	!<x11-proto/compositeproto-0.4.2-r2
	!<x11-proto/damageproto-1.2.1-r2
	!<x11-proto/dmxproto-2.3.1-r2
	!<x11-proto/dri2proto-2.8-r2
	!<x11-proto/dri3proto-1.0-r1
	!<x11-proto/fixesproto-5.0-r2
	!<x11-proto/fontsproto-2.1.3-r1
	!<x11-proto/glproto-1.4.17-r2
	!<x11-proto/inputproto-2.3.2-r1
	!<x11-proto/kbproto-1.0.7-r1
	!<x11-proto/presentproto-1.1-r1
	!<x11-proto/randrproto-1.5.0-r1
	!<x11-proto/recordproto-1.14.2-r2
	!<x11-proto/renderproto-0.11.1-r2
	!<x11-proto/resourceproto-1.2.0-r1
	!<x11-proto/scrnsaverproto-1.2.2-r2
	!<x11-proto/trapproto-3.4.3-r1
	!<x11-proto/videoproto-2.3.3-r1
	!<x11-proto/xcmiscproto-1.2.2-r1
	!<x11-proto/xextproto-7.3.0-r1
	!<x11-proto/xf86bigfontproto-1.2.0-r2
	!<x11-proto/xf86dgaproto-2.1-r3
	!<x11-proto/xf86driproto-2.1.1-r2
	!<x11-proto/xf86miscproto-0.9.3-r1
	!<x11-proto/xf86vidmodeproto-2.3.1-r2
	!<x11-proto/xineramaproto-1.2.1-r2
	!<x11-proto/xproto-7.0.31-r1

	!x11-proto/fontcacheproto
	!x11-proto/xf86rushproto"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}
