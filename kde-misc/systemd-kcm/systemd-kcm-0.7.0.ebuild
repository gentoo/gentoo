# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/systemd-kcm/systemd-kcm-0.7.0.ebuild,v 1.1 2015/06/29 20:43:23 johu Exp $

EAPI=5

MY_PN="kcmsystemd"
inherit kde4-base

DESCRIPTION="KDE control module for systemd"
HOMEPAGE="https://projects.kde.org/projects/playground/sysadmin/systemd-kcm"
SRC_URI="https://github.com/rthomsen/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

IUSE="debug"
LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/boost-1.45
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kcmshell)
	sys-apps/systemd
"

# only needed for 0.7.0 and 1.1.0
S="${WORKDIR}"/${MY_PN}-${PV}
