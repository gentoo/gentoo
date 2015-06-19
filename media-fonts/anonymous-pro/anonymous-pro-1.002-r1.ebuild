# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/anonymous-pro/anonymous-pro-1.002-r1.ebuild,v 1.3 2015/03/09 11:04:31 yngwin Exp $

EAPI=5
inherit font

MY_PN="AnonymousPro"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Monospaced truetype font designed with coding in mind"
HOMEPAGE="http://www.marksimonson.com/fonts/view/anonymous-pro"
SRC_URI="http://www.marksimonson.com/assets/content/fonts/${MY_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86 ~x64-macos"
IUSE=""

DEPEND="app-arch/unzip"
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_P}.001"
FONT_S="${S}"
FONT_SUFFIX="ttf"
