# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Framework for manipulating strings using various encodings"
LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls"

DEPEND="nls? ( $(add_qt_dep linguist-tools) )"
