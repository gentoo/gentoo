# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Manage multiple Gradle versions on one system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/Flow/${PN}.git"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="app-admin/eselect"

src_install() {
	insinto /usr/share/eselect/modules
	doins gradle.eselect
}
