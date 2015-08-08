# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Virtual Memory Toucher, portable file system cache diagnostics and control"
HOMEPAGE="http://hoytech.com/vmtouch/"
SRC_URI="https://github.com/hoytech/${PN}/archive/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${PN}-${P}

src_install() {
	default
	doman vmtouch.8
}
