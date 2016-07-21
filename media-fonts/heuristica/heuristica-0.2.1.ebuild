# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit font

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="https://code.google.com/p/evristika/"
SRC_URI="https://evristika.googlecode.com/files/${PN}-ttf-${PV}.tar.xz
	https://evristika.googlecode.com/files/${PN}-otf-${PV}.tar.xz
	https://evristika.googlecode.com/files/${PN}-pfb-${PV}.tar.xz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="otf pfb ttf"
FONT_S="${S}"
DOCS="FontLog.txt"
