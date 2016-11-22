# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit git-r3

DESCRIPTION="Yahoo! (2016) Protocol Plugin for Pidgin"
HOMEPAGE="https://github.com/EionRobb/funyahoo-plusplus"
EGIT_REPO_URI="https://github.com/EionRobb/funyahoo-plusplus"
LICENSE="GPL-3+"
SLOT="0"

RDEPEND="net-im/pidgin
	dev-libs/json-glib"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
