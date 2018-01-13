# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/23" # based on SONAME
KEYWORDS="~amd64 -arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

DEPEND="virtual/pkgconfig"

MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/IlmBaseConfig.h )

PATCHES=(
	"${FILESDIR}/${PN}-2.2.0-Remove-register-keyword.patch"
	"${FILESDIR}/${PN}-2.2.1-use-gnuinstalldirs.patch"
)
