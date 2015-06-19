# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/leapcast/leapcast-9999.ebuild,v 1.2 2015/03/03 06:46:18 bman Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/dz0ny/leapcast.git"
	inherit git-2
else
	SRC_URI="https://github.com/dz0ny/leapcast/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Simple ChromeCast emulation app"
HOMEPAGE="https://github.com/dz0ny/leapcast"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-python/requests[$PYTHON_USEDEP]
	www-servers/tornado[$PYTHON_USEDEP]"
