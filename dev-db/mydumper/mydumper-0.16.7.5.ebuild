# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A high-performance multi-threaded backup (and restore) toolset for MySQL"
HOMEPAGE="https://github.com/mydumper/mydumper"
SRC_URI="https://github.com/mydumper/mydumper/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-arch/zstd
	dev-db/mysql-connector-c:=
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/openssl:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.13.1-atomic.patch" #654314
	"${FILESDIR}/${PN}-0.15-Do-not-overwrite-the-user-CFLAGS.patch"
)
