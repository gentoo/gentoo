# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# git.foss21.org is the official repository per upstream
DESCRIPTION="A skinny libtool implementation, written in C"
HOMEPAGE="https://git.foss21.org/slibtool"
SRC_URI="https://dl.midipix.org/slibtool/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"

src_configure() {
	./configure --host=${CHOST} --prefix="${EPREFIX}"/usr || die
}
