# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Single UNIX Specification, Version 5, 2024 Edition"
HOMEPAGE="https://publications.opengroup.org/"
SRC_URI="https://pubs.opengroup.org/onlinepubs/9799919799/download/susv5.tar.bz2"
S="${WORKDIR}/susv5-html"

LICENSE="sus4-copyright"
SLOT="5"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
RESTRICT="mirror"

src_install() {
	dodoc -r *
}
