# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

GIT_COMMIT=54b2e307af763ce87bc8c88e80785d8114bf38dd

DESCRIPTION="System information and benchmark tool for Linux systems"
HOMEPAGE="https://github.com/lpereira/hardinfo"
SRC_URI="https://github.com/lpereira/hardinfo/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-libs/json-glib
	dev-libs/glib:2
	net-libs/libsoup
	sys-libs/zlib
	x11-libs/cairo
	>=x11-libs/gtk+-3.0:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${GIT_COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DHARDINFO_GTK3=1
		-DHARDINFO_DEBUG=$(usex debug 1 0)
	)
	cmake_src_configure
}
