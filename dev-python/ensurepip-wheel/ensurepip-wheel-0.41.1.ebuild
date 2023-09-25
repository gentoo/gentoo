# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pypi

DESCRIPTION="Shared wheel wheel for use in pip tests"
HOMEPAGE="https://pypi.org/project/wheel/"
SRC_URI="$(pypi_wheel_url "${PN#ensurepip-}")"
S=${DISTDIR}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	insinto /usr/lib/python/ensurepip
	doins "${A}"
}
