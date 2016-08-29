# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/liske/${PN}.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/liske/${PN}/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Restart daemons after library updates"
HOMEPAGE="https://fiasko-nw.net/~thomas/tag/needrestart.html https://github.com/liske/needrestart"

SLOT="0"
LICENSE="GPL-2+"

RDEPEND="
	>=sys-apps/sed-4.2.2
	dev-perl/libintl-perl
	dev-perl/Module-Find
	dev-perl/Module-ScanDeps
	dev-perl/Proc-ProcessTable
	dev-perl/Sort-Naturally
	dev-perl/TermReadKey
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_install() {
	default
	doman man/*.1
	dodoc -r ex
}
