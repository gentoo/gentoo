# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/euroelessar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/euroelessar/${PN}.git"
fi

inherit cmake ${GIT_ECLASS}

DESCRIPTION="Qt XMPP library"
HOMEPAGE="https://github.com/euroelessar/jreen"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	media-libs/speex
	net-libs/libgsasl
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DJREEN_FORCE_QT4=OFF
	)
	cmake_src_configure
}
