# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

EGIT_SUB_PROJECT="apps"
EGIT_URI_APPEND="${PN}"

inherit enlightenment

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org/p.php?p=about/terminology"

RDEPEND=">=dev-libs/efl-1.15.1
	>=media-libs/elementary-1.15.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
