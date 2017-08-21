# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Directory hierarchy mapping tool from FreeBSD"
HOMEPAGE="https://github.com/archiecobbs/mtree-port"
SRC_URI="https://github.com/archiecobbs/mtree-port/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}-port-${PV}"

src_prepare() {
	default
	# don't install unneeded docs
	sed -i '/doc_DATA=/d' Makefile.am || die
	eautoreconf
}

src_install() {
	default

	# avoid conflict with app-arch/libarchive
	rm "${ED%/}/usr/share/man/man5/mtree.5"
}
