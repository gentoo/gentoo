# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnustep-2

S=${WORKDIR}/${PN/c/C}

DESCRIPTION="Cenon is a vector graphics tool for GNUstep, OpenStep and MacOSX"
HOMEPAGE="http://www.cenon.info/"
SRC_URI="http://www.cenon.zone/download/source/${P/c/C}.tar.bz2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="Cenon"
IUSE=""

DEPEND=""
RDEPEND=">=gnustep-libs/cenonlibrary-4.0.0"

PATCHES=(
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-invalid_array_syntax.patch
	)
