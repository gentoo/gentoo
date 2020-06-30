# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Some nice themes for Sawfish"
HOMEPAGE="https://packages.qa.debian.org/s/sawfish-themes.html"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=x11-wm/sawfish-1"

src_install() {
	insinto /usr/share/sawfish/themes
	doins -r .
}
