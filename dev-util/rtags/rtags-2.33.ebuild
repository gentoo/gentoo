# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils systemd

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Andersbakken/rtags.git"
	SRC_URI=""
else
	SRC_URI="https://github.com/Andersbakken/${PN}/releases/download/v${PV}/rtags-${PV}.tar.bz2"
fi

DESCRIPTION="A client/server indexer for C/C++/ObjC[++] with integration for Emacs"
HOMEPAGE="http://www.rtags.net/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ssl"

DEPEND="sys-devel/clang:*
	sys-libs/ncurses:0
	sys-libs/zlib
	ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	systemd_douserunit \
		"${FILESDIR}/rdm.socket" \
		"${FILESDIR}/rdm.service"
}
