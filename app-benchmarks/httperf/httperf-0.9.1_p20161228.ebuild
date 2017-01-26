# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools vcs-snapshot

MY_COMMIT_HASH="cc888437e4572ec29a4a7209f34fbd39c31600f5"

DESCRIPTION="A tool from HP for measuring web server performance"
HOMEPAGE="https://github.com/httperf/httperf"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_COMMIT_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-linux ~x64-macos"
IUSE="debug libressl idleconn"

RDEPEND="!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	idleconn? ( dev-libs/libevent:0= )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/usr/bin
		$(use_enable debug)
		$(use_enable idleconn)
	)

	econf "${myeconfargs[@]}"
}
