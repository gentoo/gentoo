# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A skinny libtool implementation, written in C"
HOMEPAGE="https://git.midipix.org/cgit.cgi/slibtool"
SRC_URI="https://git.midipix.org/cgit.cgi/${PN}/snapshot/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"

src_configure() {
	./configure --host=${CHOST} --prefix="${EPREFIX}"/usr || die
}
