# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

DESCRIPTION="Mobile UI for kismet"
HOMEPAGE="https://github.com/elkentaro/KismetMobileDashboard"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/elkentaro/KismetMobileDashboard.git"
else
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
	SRC_URI="https://github.com/elkentaro/KismetMobileDashboard/archive/V1.5-beta.1.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/KismetMobileDashboard-1.5-beta.1"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="net-wireless/kismet"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	KIS_SRC_DIR="/usr/share/kismet" emake
}

src_install() {
	DESTDIR="${ED}" KIS_SRC_DIR="/usr/share/kismet" emake install
}
