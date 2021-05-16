# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/mgorny/shadowman"
inherit git-r3

DESCRIPTION="Unified compiler shadow link directory updater"
HOMEPAGE="https://github.com/mgorny/shadowman"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-admin/eselect"
DEPEND="${RDEPEND}"

src_install() {
	# tool modules are split into their respective packages
	emake DESTDIR="${D}" install \
		INSTALL_MODULES_TOOL=""
	keepdir /usr/share/shadowman/tools
}
