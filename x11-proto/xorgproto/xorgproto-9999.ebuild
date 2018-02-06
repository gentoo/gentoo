# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/proto/${PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} meson

DESCRIPTION="X.Org combined protocol headers"
HOMEPAGE="https://cgit.freedesktop.org/xorg/proto/xorgproto/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://xorg.freedesktop.org/archive/individual/proto/${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	!x11-proto/bigreqsproto
	!x11-proto/compositeproto
	!x11-proto/damageproto
	!x11-proto/dmxproto
	!x11-proto/dri2proto
	!x11-proto/dri3proto
	!x11-proto/fixesproto
	!x11-proto/fontsproto
	!x11-proto/glproto
	!x11-proto/inputproto
	!x11-proto/kbproto
	!x11-proto/presentproto
	!x11-proto/randrproto
	!x11-proto/recordproto
	!x11-proto/renderproto
	!x11-proto/resourceproto
	!x11-proto/scrnsaverproto
	!x11-proto/trapproto
	!x11-proto/videoproto
	!x11-proto/xcmiscproto
	!x11-proto/xextproto
	!x11-proto/xf86bigfontproto
	!x11-proto/xf86dgaproto
	!x11-proto/xf86driproto
	!x11-proto/xf86miscproto
	!x11-proto/xf86vidmodeproto
	!x11-proto/xineramaproto
	!x11-proto/xproto

	!x11-proto/fontcacheproto
	!x11-proto/printproto
	!x11-proto/xf86rushproto"
RDEPEND=""

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}
