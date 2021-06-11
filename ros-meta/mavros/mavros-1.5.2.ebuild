# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Metapackage for mavros packages"
LICENSE="metapackage"
SLOT="0"
IUSE=""
HOMEPAGE="https://wiki.ros.org/mavros"

RDEPEND="
	dev-ros/mavros_msgs
	dev-ros/libmavconn
	dev-ros/mavros
	dev-ros/mavros_extras
"
DEPEND="${RDEPEND}"
[ "${PV}" = "9999" ] || KEYWORDS="~amd64 ~arm"
