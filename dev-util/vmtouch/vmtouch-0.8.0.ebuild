# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/vmtouch/vmtouch-0.8.0.ebuild,v 1.1 2014/07/12 10:11:34 dlan Exp $

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
