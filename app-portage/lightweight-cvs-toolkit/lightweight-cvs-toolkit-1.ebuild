# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/lightweight-cvs-toolkit/lightweight-cvs-toolkit-1.ebuild,v 1.1 2015/02/08 08:55:56 mgorny Exp $

EAPI=5

DESCRIPTION="Tools to create partial CVS checkout, merge PRs and revert commits"
HOMEPAGE="https://bitbucket.org/mgorny/lightweight-cvs-toolkit"
SRC_URI="https://bitbucket.org/mgorny/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-vcs/cvs
	dev-vcs/git"

src_install() {
	dobin lcvs-*
	dodoc README
}
