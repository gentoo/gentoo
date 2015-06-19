# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmygpo-qt/libmygpo-qt-1.0.7.ebuild,v 1.3 2014/06/16 13:11:01 nimiux Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="Qt/C++ library wrapping the gpodder.net webservice"
HOMEPAGE="http://wiki.gpodder.org/wiki/Libmygpo-qt"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gpodder/libmygpo-qt.git"
	KEYWORDS=""
	SRC_URI=""
	inherit git-2
else
	KEYWORDS="amd64 x86"
	SRC_URI="https://github.com/gpodder/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="dev-qt/qtcore:4
	>=dev-libs/qjson-0.5"
DEPEND="${RDEPEND}
	dev-qt/qttest:4
	virtual/pkgconfig"

DOCS=( AUTHORS README )
