# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

OPENSUSE_RELEASE="12.2"
DESCRIPTION="Simplistic, technical sans serif - openSUSE font"
HOMEPAGE="http://jimmac.musichall.cz/log/?p=439"
SRC_URI="https://api.opensuse.org/public/source/openSUSE:${OPENSUSE_RELEASE}/fifth-leg-font/opensuse-font-${P}.tar.bz2"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="otf sfd"
FONT_S="${WORKDIR}"
S="${FONT_S}"
