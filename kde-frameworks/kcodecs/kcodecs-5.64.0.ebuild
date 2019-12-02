# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="Framework for manipulating strings using various encodings"
LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="nls"

BDEPEND="
	dev-util/gperf
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
