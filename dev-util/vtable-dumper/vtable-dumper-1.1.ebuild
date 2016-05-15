# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A tool to list content of virtual tables in a shared library"
HOMEPAGE="https://github.com/lvc/vtable-dumper"
SRC_URI="https://github.com/lvc/vtable-dumper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/elfutils:0="
RDEPEND="${DEPEND}"

src_install() {
	emake prefix="${ED%/}/usr" install
	einstalldocs
}
