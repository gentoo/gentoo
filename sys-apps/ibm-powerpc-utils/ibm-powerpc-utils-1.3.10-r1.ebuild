# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd

DESCRIPTION="Utilities for the maintenance of the IBM and Apple PowerPC platforms"
HOMEPAGE="https://github.com/ibm-power-utilities/powerpc-utils"
SRC_URI="https://github.com/ibm-power-utilities/${PN//ibm-}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P//ibm-}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~ppc ~ppc64"
IUSE="+rtas"

RDEPEND="
	!<sys-apps/powerpc-utils-1.1.3.18-r4
	sys-process/numactl
	rtas? ( >=sys-libs/librtas-2.0.2 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.5-docdir.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		--with-systemd="$(systemd_get_systemunitdir)" \
		$(use_with rtas librtas)
}
