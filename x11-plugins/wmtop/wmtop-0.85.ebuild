# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="dockapp for monitoring the top three processes using cpu or memory"
HOMEPAGE="https://www.dockapps.net/wmtop"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=x11-libs/libdockapp-0.7:=
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

# Incorrect path in this tarball version
S=${WORKDIR}/dockapps-be3f170

src_prepare() {
	eapply_user

	eautoreconf
}
