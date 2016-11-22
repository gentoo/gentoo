# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/spotify/docker-gc.git"

inherit git-r3

DESCRIPTION="Docker garbage collection of containers and images"
HOMEPAGE="https://github.com/spotify/docker-gc/"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="app-emulation/docker"

src_install() {
	dosbin docker-gc
	dodoc README.md
}
