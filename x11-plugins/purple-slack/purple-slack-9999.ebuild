# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A libpurple plugin for the web-based slack api."
HOMEPAGE="https://github.com/dylex/slack-libpurple"
EGIT_REPO_URI="https://github.com/dylex/slack-libpurple"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="net-im/pidgin"
DEPEND="${RDEPEND}
	dev-vcs/git"
