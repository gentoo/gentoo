# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/collada-dom/collada-dom-2.4.3_pre20150112.ebuild,v 1.1 2015/01/12 15:25:42 aballier Exp $

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/rdiankov/collada-dom"
fi

inherit ${SCM} cmake-utils

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
elif [ "${PV%_pre*}" != "${PV}" ]; then
	# snapshot
	KEYWORDS="~amd64 ~arm"
	SRC_URI="mirror://gentoo/${P}.tar.xz"
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/rdiankov/collada-dom/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="COLLADA Document Object Model (DOM) C++ Library"
HOMEPAGE="https://github.com/rdiankov/collada-dom"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=[minizip]
	dev-libs/libxml2
	dev-libs/libpcre[cxx]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
