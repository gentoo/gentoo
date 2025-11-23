# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

GIT_VERSION="c810abffbf6dc6f1f354b0c545abe65311203fd8"

DESCRIPTION="VDR plugin: control a horz. or vert. actuator attached through the parallel port"
HOMEPAGE="https://ventoso.org/luca/vdr/"
SRC_URI="https://github.com/olivluca/vdr-actuator-plugin/archive/${GIT_VERSION}.tar.gz -> ${PF}.tar.gz"
S="${WORKDIR}/${PN}-plugin-${GIT_VERSION}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=media-video/vdr-2.4"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	fix_vdr_libsi_include "${S}/scanfilter.h"
	fix_vdr_libsi_include "${S}/scanfilter.c"
}
