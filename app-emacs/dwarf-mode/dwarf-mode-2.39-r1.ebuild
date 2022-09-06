# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs mode to browse DWARF information"
HOMEPAGE="https://sourceware.org/binutils/"
SRC_URI="mirror://gnu/binutils/binutils-${PV}.tar.xz"
S="${WORKDIR}"/binutils-${PV}/binutils

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!sys-devel/binutils[emacs(-)]"

SITEFILE="50${PN}-gentoo.el"
