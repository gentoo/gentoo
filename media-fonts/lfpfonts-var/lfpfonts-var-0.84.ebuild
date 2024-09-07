# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="Linux Font Project variable-width fonts"
HOMEPAGE="https://sourceforge.net/projects/xfonts/"
SRC_URI="https://downloads.sourceforge.net/xfonts/${PN}-src-${PV}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~loong ppc ~riscv ~s390 sparc x86"
IUSE=""

S="${WORKDIR}/${PN}-src"

FONT_S="${S}/src"

DOCS="${S}/doc/*"

# Only installs fonts
RESTRICT="strip binchecks"
