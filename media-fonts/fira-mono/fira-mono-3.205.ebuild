# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font versionator

MY_P="FiraMonoFonts$(delete_all_version_separators)"
MY_MINOR="$(get_version_component_range 2)"

DESCRIPTION="Default monospaced typeface for FirefoxOS, designed for legibility"
HOMEPAGE="http://www.carrois.com/fira-4-1/"
SRC_URI="http://www.carrois.com/downloads/fira_mono_$(get_major_version)_${MY_MINOR:0:1}/${MY_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_P}
FONT_S="${S}/OTF"
FONT_SUFFIX="otf"
