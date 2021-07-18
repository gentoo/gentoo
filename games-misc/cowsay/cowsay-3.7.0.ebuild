# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Configurable talking ASCII cow (and other characters)"
HOMEPAGE="https://cowsay.diamonds https://github.com/cowsay-org/cowsay"
SRC_URI="https://github.com/cowsay-org/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~mips ~ppc64 ~x86 ~x64-macos ~x64-solaris"

RDEPEND="dev-lang/perl"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.7-head-in.patch"
	"${FILESDIR}/${PN}-3.0.7-mech-and-cow.patch"
)

src_prepare() {
	default

	sed -i 's#/usr/local#/${EPREFIX}/usr#' Makefile || die
}
