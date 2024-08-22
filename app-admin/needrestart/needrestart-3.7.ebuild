# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/liske/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/liske/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Restart daemons after library updates"
HOMEPAGE="https://fiasko-nw.net/~thomas/tag/needrestart.html https://github.com/liske/needrestart"
LICENSE="GPL-2+"
SLOT="0"
IUSE="systemd"

RDEPEND="
	>=sys-apps/sed-4.2.2
	dev-lang/perl:=
	dev-perl/libintl-perl
	dev-perl/Module-Find
	dev-perl/Module-ScanDeps
	dev-perl/Proc-ProcessTable
	dev-perl/Sort-Naturally
	dev-perl/TermReadKey
	!systemd? ( sys-apps/init-system-helpers )
	amd64? ( sys-apps/iucode_tool )
	x86? ( sys-apps/iucode_tool )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_install() {
	default
	doman man/*.1
	dodoc -r ex
}
