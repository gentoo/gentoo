# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/powerline-symbols/powerline-symbols-20150224.ebuild,v 1.1 2015/02/24 16:39:46 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="OpenType Unicode font with symbols for Powerline/Airline"
HOMEPAGE="https://github.com/powerline/powerline"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"
# We're redistributing just the (unversioned) font from the upstream repo here

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

FONT_S="${S}"
FONT_SUFFIX="otf"
FONT_CONF=( 10-powerline-symbols.conf )
DOCS="README.rst"
