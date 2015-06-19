# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/git-crypt/git-crypt-0.5.0.ebuild,v 1.1 2015/06/14 10:30:09 patrick Exp $

EAPI=5

DESCRIPTION="transparent file encryption in git"
HOMEPAGE="https://www.agwa.name/projects/git-crypt/"
SRC_URI="https://github.com/AGWA/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64 ~x86"

RDEPEND="dev-vcs/git"
DEPEND="${RDEPEND}"

src_install() {
	mkdir -p "${D}"/usr/bin
	emake PREFIX="${D}"/usr install
}
