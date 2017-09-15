# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Metapackage for mavros packages"
LICENSE="metapackage"
SLOT="0"
IUSE=""
HOMEPAGE="http://wiki.ros.org/mavros"

RDEPEND="
	dev-ros/libmavconn
	dev-ros/mavros
	dev-ros/mavros_extras
	dev-ros/mavros_msgs
"
DEPEND="${RDEPEND}"
[ "${PV}" = "9999" ] || KEYWORDS="~amd64 ~arm"
