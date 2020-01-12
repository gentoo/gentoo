# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
inherit ecm kde.org

DESCRIPTION="C++ library for controlling asynchronous tasks"
HOMEPAGE="https://api.kde.org/kasync/html/index.html"

if [[ ${KDE_BUILD_TYPE} = release ]]; then
	SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2+"
SLOT="5"
