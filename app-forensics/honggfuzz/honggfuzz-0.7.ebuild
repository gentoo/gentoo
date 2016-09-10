# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A general purpose fuzzer with feedback support"
HOMEPAGE="http://google.github.io/honggfuzz/"
SRC_URI="https://github.com/google/honggfuzz/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	sys-libs/binutils-libs:=
	sys-libs/libunwind
"

DEPEND="${RDEPEND}"

DOCS=(
	CHANGELOG
	COPYING
	CONTRIBUTING
	README.md
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}

	einstalldocs
}
