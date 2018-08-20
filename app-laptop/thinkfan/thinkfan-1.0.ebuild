# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils readme.gentoo-r1

DESCRIPTION="simple fan control program for thinkpads"
HOMEPAGE="http://thinkfan.sourceforge.net"
SRC_URI="https://github.com/vmatare/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="atasmart nvidia +yaml"

DEPEND="atasmart? ( dev-libs/libatasmart )
	yaml? ( dev-cpp/yaml-cpp )"
RDEPEND="${DEPEND}
	nvidia? ( x11-drivers/nvidia-drivers )"

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s:share/doc/${PN}:share/doc/${PF}:" \
		-i CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs+=(
		-DUSE_NVML="$(usex nvidia)"
		-DUSE_ATASMART="$(usex atasmart)"
		-DUSE_YAML="$(usex yaml)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	readme.gentoo_create_doc
}

DOC_CONTENTS="Please read the documentation and copy an
appropriate file to /etc/thinkfan.conf."
