# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/inconsolata-hellenic/inconsolata-hellenic-1.19.ebuild,v 1.1 2015/03/07 08:30:53 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="Hellenisation of the wonderful, monospace, open/free font Inconsolata by Raph Levien"
HOMEPAGE="http://www.cosmix.org/software/"
SRC_URI="http://www.cosmix.org/software/files/InconsolataHellenic.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S=${S}
FONT_SUFFIX="ttf"
