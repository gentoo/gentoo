# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/multimon-ng/multimon-ng-9999.ebuild,v 1.6 2014/04/16 15:01:06 zerochaos Exp $

EAPI=5

inherit qt4-r2

DESCRIPTION="a fork of multimon, decodes multiple digital transmission modes"
HOMEPAGE="https://github.com/EliasOenal/multimonNG"

if [[ ${PV} == 9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="https://github.com/EliasOenal/multimonNG.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/EliasOenal/multimonNG/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/multimonNG-${PV}
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="pulseaudio"

DEPEND="pulseaudio? ( media-sound/pulseaudio )
	dev-qt/qtcore:4
	x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	if use !pulseaudio; then
		sed -i -e 's/-lpulse-simple//' -e 's/-lpulse//' -e 's/PULSE/DUMMY/' ${PN}.pro || die
	fi
	qt4-r2_src_prepare
}
src_install() {
	dobin ${PN}
}
