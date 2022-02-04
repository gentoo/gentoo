# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="transparent file encryption in git"
HOMEPAGE="https://www.agwa.name/projects/git-crypt/"
SRC_URI="https://github.com/AGWA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}"

src_install() {
	mkdir -p "${D}"/usr/bin || die
	emake PREFIX="${D}"/usr install
}
