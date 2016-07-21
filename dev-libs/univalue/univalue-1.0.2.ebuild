# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="C++ universal value object and JSON library"
HOMEPAGE="https://github.com/jgarzik/univalue"
LICENSE="MIT"

SRC_URI="https://codeload.github.com/jgarzik/${PN}/tar.gz/v${PV} -> ${P}.tgz"
SLOT="0/0"

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	./autogen.sh || die
}

src_configure() {
	econf --disable-static
}

src_install() {
	default_src_install
	prune_libtool_files
}