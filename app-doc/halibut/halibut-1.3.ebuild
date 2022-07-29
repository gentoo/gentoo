# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="yet another free document preparation system"
HOMEPAGE="https://www.chiark.greenend.org.uk/~sgtatham/halibut/"
SRC_URI="https://www.chiark.greenend.org.uk/~sgtatham/${PN}/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~riscv ~sparc x86"
