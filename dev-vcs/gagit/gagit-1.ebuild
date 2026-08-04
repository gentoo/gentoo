# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Gentoo AGit workflow tool"
HOMEPAGE="https://gitweb.gentoo.org/proj/gagit.git/"
SRC_URI="
	https://gitweb.gentoo.org/proj/gagit.git/snapshot/${P}.tar.bz2
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-vcs/git
	virtual/editor
"
