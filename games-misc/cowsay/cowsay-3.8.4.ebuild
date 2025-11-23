# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Configurable talking ASCII cow (and other characters)"
HOMEPAGE="https://cowsay.diamonds https://github.com/cowsay-org/cowsay"
SRC_URI="https://github.com/cowsay-org/cowsay/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~mips ~ppc64 ~riscv ~x86 ~x64-macos ~x64-solaris"

RDEPEND="dev-lang/perl"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-head-in.patch"
)

src_prepare() {
	default
	sed -i "s|fB%PREFIX%|fB${EPREFIX}/usr|g" man/man1/cowsay.1 || die
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	keepdir /etc/${PN}/cowpath.d
	einstalldocs
}
