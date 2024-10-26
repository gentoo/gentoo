# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: make osd menu configurable via config-file"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-menuorg"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-menuorg/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-menuorg-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr[menuorg]
	dev-cpp/libxmlpp:2.6
	dev-cpp/glibmm:2"
RDEPEND="${DEPEND}"

src_compile() {
	emake CXXFLAGS+=-std=c++11
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/menuorg
	doins menuorg.xml
}
