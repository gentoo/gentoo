# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/efont-unicode/efont-unicode-0.4.2-r1.ebuild,v 1.15 2013/10/21 12:07:35 grobian Exp $

inherit font font-ebdftopcf

MY_P="${PN}-bdf-${PV}"

DESCRIPTION="The /efont/ Unicode Bitmap Fonts"
HOMEPAGE="http://openlab.jp/efont/unicode/"
SRC_URI="http://openlab.jp/efont/dist/unicode-bdf/${MY_P}.tar.bz2"

# naga10 has free-noncomm license
LICENSE="public-domain BAEKMUK BSD MIT HPND free-noncomm"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x64-macos"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_S=${S}
DOCS="README* COPYRIGHT ChangeLog INSTALL"

# Only installs fonts
RESTRICT="strip binchecks"
