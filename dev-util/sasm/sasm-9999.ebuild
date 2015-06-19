# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/sasm/sasm-9999.ebuild,v 1.1 2014/02/24 18:16:40 maksbotan Exp $

EAPI=5

inherit qt4-r2

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/Dman95/SASM.git"
	SRC_URI=""
	inherit git-r3
else
	SRC_URI="https://github.com/Dman95/SASM/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/SASM-${PV}"
fi

DESCRIPTION="Simple crossplatform IDE for NASM assembly language"
HOMEPAGE="http://dman95.github.io/SASM/"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
REPEND="${DEPEND}
	dev-lang/nasm
	sys-devel/gdb
"
