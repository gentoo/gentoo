# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A ncurses file manager written in C with vim like keybindings"
HOMEPAGE="https://github.com/mananapr/cfiles"
SRC_URI="https://github.com/mananapr/cfiles/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-libs/ncurses:=
	app-text/poppler[utils]
"
RDEPEND="${DEPEND}"

src_install(){
	dobin cfiles
	dobin scripts/displayimg_uberzug
	dobin scripts/clearimg_uberzug
	dobin scripts/displayimg
	doman cfiles.1
}
