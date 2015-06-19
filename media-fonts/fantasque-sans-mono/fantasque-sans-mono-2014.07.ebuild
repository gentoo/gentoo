# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/fantasque-sans-mono/fantasque-sans-mono-2014.07.ebuild,v 1.1 2015/03/07 09:04:03 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="Programming font designed with functionality in mind and with some handwriting-like fuzziness"
HOMEPAGE="http://openfontlibrary.org/en/font/fantasque-sans-mono"
SRC_URI="http://openfontlibrary.org/assets/downloads/${PN}/db52617ba875d08cbd8e080ca3d9f756/${PN}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}/OTF"
FONT_SUFFIX="otf"
DOCS="README.md"
