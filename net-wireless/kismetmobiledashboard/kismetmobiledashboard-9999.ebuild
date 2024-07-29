# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

src_prepare() {
	sed -i 's#\$(INSTALL)#install#' Makefile
	default
}

src_compile() {
	KIS_SRC_DIR="/usr/share/kismet" emake
}

src_install() {
	DESTDIR="${ED}" KIS_SRC_DIR="/usr/share/kismet" emake install
}
