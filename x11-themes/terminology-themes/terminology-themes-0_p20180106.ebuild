# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils

EGIT_COMMIT_HASH="ba7b71ffd290cbce4bf87d47276fa516c6563345"

DESCRIPTION="Color schemes for the Terminology terminal emulator"
HOMEPAGE="https://charlesmilette.net/terminology-themes/"
SRC_URI="https://github.com/sylveon/terminology-themes/archive/${EGIT_COMMIT_HASH}.tar.gz -> ${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/efl"
RDEPEND="x11-terms/terminology"

S="${WORKDIR}/${PN}-${EGIT_COMMIT_HASH}"

src_prepare() {
	default
	xdg_environment_reset
}

src_compile() {
	emake -j1
}
