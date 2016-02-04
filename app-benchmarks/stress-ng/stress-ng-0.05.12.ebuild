# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A tool to load and stress a computer system"
HOMEPAGE="http://kernel.ubuntu.com/~cking/stress-ng/"
SRC_URI="http://kernel.ubuntu.com/~cking/tarballs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/keyutils
		sys-apps/attr"
RDEPEND="${DEPEND}"
