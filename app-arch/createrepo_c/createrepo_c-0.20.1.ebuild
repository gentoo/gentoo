# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C implementation of createrepo"
HOMEPAGE="https://github.com/rpm-software-management/createrepo_c"
SRC_URI="https://github.com/rpm-software-management/createrepo_c/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Notes: Help with enabling the python support would be great

DEPEND="app-arch/bzip2:=
	app-arch/rpm
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl:=
	net-misc/curl
	sys-apps/file
	sys-libs/zlib:="
RDEPEND="${DEPEND}
	app-arch/lzma"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20.1-Include-rpm-rpmstring.h-for-rasprintf.patch
)

src_configure() {
	# Other than for python (where tests are failing) we have special no-in-tree dependencies.
	local mycmakeargs=(
		-DENABLE_DRPM=OFF
		-DENABLE_PYTHON=OFF
		-DWITH_ZCHUNK=OFF
		-DWITH_LIBMODULEMD=OFF
	)
	cmake_src_configure
}
