# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_4 )
inherit eutils python-r1

DESCRIPTION="DesktopEntry eXecution - tool to manage and launch autostart entries"
HOMEPAGE="http://e-jc.de/"
SRC_URI="https://github.com/jceb/dex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch_user
}

src_install() {
	dobin dex
	python_replicate_script "${ED}/usr/bin/dex"
	dodoc README
	doman dex.1
}
