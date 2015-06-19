# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/fifth-leg/fifth-leg-0.6.ebuild,v 1.1 2013/01/08 14:44:01 miska Exp $

EAPI=4

OPENSUSE_RELEASE="12.2"
OBS_PACKAGE="${PN}-font"

inherit font obs-download

DESCRIPTION="Simplistic, technical sans serif - openSUSE font"
HOMEPAGE="http://jimmac.musichall.cz/log/?p=439"
SRC_URI="${OBS_URI}/opensuse-font-${P}.tar.bz2"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="otf sfd"
FONT_S="${WORKDIR}"
S="${FONT_S}"
