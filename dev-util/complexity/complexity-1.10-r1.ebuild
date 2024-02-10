# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a tool designed for analyzing the complexity of C program functions"
HOMEPAGE="https://www.gnu.org/software/complexity/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

RDEPEND=">=sys-devel/autogen-5.11.7"
DEPEND="${RDEPEND}"
BDEPEND="dev-build/libtool"

DOCS=( AUTHORS ChangeLog NEWS )
