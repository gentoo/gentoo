# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/koruri/koruri-20141224.ebuild,v 1.1 2015/03/07 08:49:32 yngwin Exp $

EAPI=5
inherit font

MY_P="Koruri-${PV}"
DESCRIPTION="Japanese TrueType font based on M+ outline fonts and Open Sans"
HOMEPAGE="http://sourceforge.jp/projects/koruri/"
SRC_URI="mirror://sourceforge.jp/${PN}/62469/${MY_P}.tar.xz"

LICENSE="mplus-fonts Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# Only installs fonts
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_P}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="README*"
