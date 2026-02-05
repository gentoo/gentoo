# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="A text editor with font, color, and style capabilities for GNUstep"
HOMEPAGE="http://www.nongnu.org/backbone/"
# upstream in a weird state where this tag was never released but debian packaged it
SRC_URI="mirror://debian/pool/main/t/textedit.app/textedit.app_${PV}.orig.tar.gz"
S="${WORKDIR}/TextEdit-master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	gnustep-base/gnustep-base:=
	gnustep-base/gnustep-gui
"
DEPEND="${RDEPEND}"
