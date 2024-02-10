# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Configurable talking ASCII cow (and other characters)"
HOMEPAGE="https://cowsay.diamonds https://github.com/cowsay-org/cowsay"
SRC_URI="https://github.com/cowsay-org/cowsay/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ~mips ppc64 ~riscv x86 ~x64-macos ~x64-solaris"

RDEPEND="dev-lang/perl"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-head-in.patch"
	"${FILESDIR}/${P}-mech-and-cow.patch"
)

src_prepare() {
	default

	# no |g leaves one %PREFIX% but it makes sense in context
	sed -i "s|%PREFIX%|${EPREFIX}/usr|" cowsay.1 || die

	# patch fixes the file but need extension to be recognized
	mv share/cows/mech-and-cow{,.cow} || die
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install
	einstalldocs
}
