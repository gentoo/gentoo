# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Extra snowflake textures for Compiz"
HOMEPAGE="https://futuramerlin.com/"
EGIT_REPO_URI="https://github.com/ethus3h/${PN}.git"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""

RDEPEND=">=x11-plugins/compiz-plugins-experimental-${PV}"

src_install() {
	insinto /usr/share/compiz/snow/
	rm README.md
	doins -r *
}
