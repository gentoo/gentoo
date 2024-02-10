# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Network monitoring dockapp"
HOMEPAGE="https://www.dockapps.net/wmifs"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86"

RDEPEND=">=x11-libs/libdockapp-0.7:=
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

DOCS=( BUGS CHANGES HINTS README TODO )
