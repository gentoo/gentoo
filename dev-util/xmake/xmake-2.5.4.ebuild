# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A cross-platform build utility based on Lua"
HOMEPAGE="https://xmake.io"
SRC_URI="https://github.com/xmake-io/xmake/releases/download/v${PV}/xmake-v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

DOCS=( README.md )

src_prepare() {
	default
	sed -i '/chmod 777/d' makefile
	sed -i '/LDFLAGS_RELEASE/{s#-s##}' core/plat/linux/prefix.mak
}

src_install() {
	einstalldocs
	emake DESTDIR="${D}" PREFIX=/usr install
}
