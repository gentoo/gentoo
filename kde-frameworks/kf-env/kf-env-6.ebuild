# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Environment setting required for all KDE Frameworks apps to run"
HOMEPAGE="https://community.kde.org/Frameworks"
SRC_URI=""
S=${WORKDIR}

LICENSE="GPL-2"
SLOT="6"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	!${CATEGORY}/${PN}:5
	>=x11-misc/xdg-utils-1.2.1-r1
"

src_install() {
	einfo "Installing environment file..."

	# higher number to be sure not to kill kde4 env
	local envfile="${T}/78kf"

	echo "CONFIG_PROTECT=${EPREFIX}/usr/share/config" >> ${envfile}
	doenvd ${envfile}
}
