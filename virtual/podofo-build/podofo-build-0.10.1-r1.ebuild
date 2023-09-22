# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual package for building against PoDoFo"

SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="fontconfig idn jpeg png test tiff +tools"
RESTRICT="!test? ( test )"

RDEPEND="
	app-text/podofo:0/2[fontconfig=,idn=,jpeg=,png=,test=,tiff=,tools=]
"
