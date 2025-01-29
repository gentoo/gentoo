# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Remote Control Unit consists mainly of an IR receiver, PIC 16C84"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-rcu/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-rcu/archive/refs/tags/${PV}.tar.gz -> ${P}.tgz"
S="${WORKDIR}/vdr-plugin-rcu-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-video/vdr-2.2.0"
RDEPEND="${DEPEND}"
