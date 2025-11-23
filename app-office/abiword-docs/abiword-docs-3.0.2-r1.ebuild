# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Fully featured yet light and fast cross platform word processor documentation"
HOMEPAGE="http://www.abisource.com/"
SRC_URI="http://www.abisource.com/downloads/abiword/${PV}/source/${P}.tar.gz"
# Upstream tarball is wrongly prepared, drop in the next version
S="${WORKDIR}/${PN}-3.0.1"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND=">=app-office/abiword-${PV}"
DEPEND="${RDEPEND}"
