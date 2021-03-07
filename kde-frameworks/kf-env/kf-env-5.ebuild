# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Environment setting required for all KDE Frameworks apps to run"
HOMEPAGE="https://community.kde.org/Frameworks"
SRC_URI=""

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=x11-misc/xdg-utils-1.1.1-r1"

S=${WORKDIR}

src_install() {
	einfo "Installing environment file..."

	# higher number to be sure not to kill kde4 env
	local envfile="${T}/78kf"

	echo "CONFIG_PROTECT=${EPREFIX}/usr/share/config" >> ${envfile}
	doenvd ${envfile}
}
