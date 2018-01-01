# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Unofficial GOG.com downloader for Linux"
HOMEPAGE="https://sites.google.com/site/gogdownloader/"
EGIT_REPO_URI="https://github.com/Sude-/lgogdownloader.git"
LICENSE="WTFPL-2"
SLOT="0"
IUSE="+debug"

RDEPEND=">=app-crypt/rhash-1.3.3-r2:0=
	dev-cpp/htmlcxx:0=
	dev-libs/boost:0=
	>=dev-libs/jsoncpp-1.7:0=
	dev-libs/tinyxml2:0=
	net-libs/liboauth:0=
	>=net-misc/curl-7.32:0=[ssl]"

DEPEND="${RDEPEND}
	sys-apps/help2man
	virtual/pkgconfig"
