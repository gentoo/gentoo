# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Safely remove spaces and strange characters from filenames"
HOMEPAGE="http://detox.sourceforge.net/ https://github.com/dharple/detox"
SRC_URI="https://github.com/dharple/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~mips ppc ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="!dev-python/detox"
DEPEND="${RDEPEND}"
BDEPEND="app-alternatives/yacc
	app-alternatives/lex"

src_prepare() {
	default

	sed \
		-e '/detoxrc.sample/d' \
		-i Makefile.am || die

	eautoreconf
}

src_install() {
	default

	# bug #811945
	insinto /etc
	newins etc/detoxrc.sample detoxrc
}
