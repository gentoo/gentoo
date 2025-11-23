# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="GPGstats calculates statistics on the keys in your key-ring"
HOMEPAGE="http://www.vanheusden.com/gpgstats/"
SRC_URI="http://www.vanheusden.com/gpgstats/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-crypt/gpgme:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-flags.patch )

src_compile() {
	# Uses removed 'register' keyword, bug #894350
	append-cxxflags -std=c++14

	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" DEBUG=
}

src_install() {
	dobin gpgstats
	einstalldocs
}
