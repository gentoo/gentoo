# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="User-space tools for LinuxPPS"
HOMEPAGE="https://github.com/redlab-i/pps-tools"
SRC_URI="https://github.com/redlab-i/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2-build.patch
	"${FILESDIR}"/${PN}-1.0.1-install.patch
)

src_prepare() {
	default
	tc-export CC
}
