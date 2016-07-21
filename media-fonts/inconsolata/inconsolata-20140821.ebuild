# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font

DESCRIPTION="A beautiful sans-serif monotype font designed for code listings"
HOMEPAGE="https://www.google.com/fonts/specimen/Inconsolata
	https://code.google.com/p/googlefontdirectory/source/browse/ofl/inconsolata/?name=default"
SRC_URI="https://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${WORKDIR}/${P}"

# Only installs fonts
RESTRICT="binchecks strip test"
