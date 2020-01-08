# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

MY_P="${PN}-bdf-${PV}"

DESCRIPTION="The /efont/ Unicode Bitmap Fonts"
HOMEPAGE="http://openlab.jp/efont/unicode/"
SRC_URI="http://openlab.jp/efont/dist/unicode-bdf/${MY_P}.tar.bz2"

# naga10 has free-noncomm license
LICENSE="public-domain BAEKMUK BSD MIT HPND free-noncomm"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x64-macos"
IUSE=""
# Only installs fonts
RESTRICT="strip binchecks"

S="${WORKDIR}/${MY_P}"

FONT_S="${S}"
DOCS="README* COPYRIGHT ChangeLog INSTALL"
