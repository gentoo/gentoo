# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Framework for manipulating strings using various encodings"
LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="nls"

DEPEND="
	dev-util/gperf
	nls? ( $(add_qt_dep linguist-tools) )
"
