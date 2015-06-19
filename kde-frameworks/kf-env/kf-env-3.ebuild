# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kf-env/kf-env-3.ebuild,v 1.4 2015/06/12 16:23:49 kensington Exp $

EAPI=5

DESCRIPTION="Environment setting required for all KDE Frameworks apps to run"
HOMEPAGE="http://community.kde.org/Frameworks"
SRC_URI=""

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND=">=x11-misc/xdg-utils-1.1.0_rc3_p20150119"

S=${WORKDIR}

src_install() {
	einfo "Installing environment file..."

	# higher number to be sure not to kill kde4 env
	local envfile="${T}/78kf"

	echo "CONFIG_PROTECT=${EPREFIX}/usr/share/config" >> ${envfile}
	doenvd ${envfile}
}
