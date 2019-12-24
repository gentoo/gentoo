# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

MY_P="xfonts-cronyx_${PV}"

DESCRIPTION="Cronyx Cyrillic bitmap fonts for X"
HOMEPAGE="https://packages.debian.org/source/sid/xfonts-cronyx"
SRC_URI="
	mirror://debian/pool/main/x/xfonts-cronyx/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/x/xfonts-cronyx/${MY_P}-6.diff.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86"

S="${WORKDIR}/${MY_P//_/-}.orig"

PATCHES=( "${WORKDIR}"/${MY_P}-6.diff )

DOCS="Changelog.en xcyr.README.* xrus.README"
FONT_PN="cronyx"
FONT_S="${S}/75dpi ${S}/100dpi ${S}/misc"
FONTDIR="/usr/share/fonts/cronyx"
