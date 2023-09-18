# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Dockapp for monitoring the top three processes using cpu or memory"
HOMEPAGE="https://www.dockapps.net/wmtop"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"
# Incorrect path in this tarball version
S="${WORKDIR}/dockapps-be3f170"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=x11-libs/libdockapp-0.7:=
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	eapply_user
	eautoreconf
}
