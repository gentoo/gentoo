# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Style neutral scalable cursor theme (black version)"
HOMEPAGE="http://jimmac.musichall.cz/"
SRC_URI="mirror://debian/pool/main/d/dmz-cursor-theme/dmz-cursor-theme_${PV}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="x11-apps/xcursorgen"

S="${WORKDIR}/dmz-cursor-theme-${PV}"

src_compile() {
	cd "${S}/DMZ-Black/pngs" || die
	./make.sh || die
}

src_install() {
	insinto /usr/share/icons/Vanilla-DMZ-AA/cursors
	doins -r DMZ-Black/xcursors/.
	insinto /usr/share/icons/Vanilla-DMZ-AA
	doins DMZ-Black/index.theme
}
