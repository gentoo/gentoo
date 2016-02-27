# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Atmospheric Modelling for ALMA Observatory"
HOMEPAGE="https://svn.cv.nrao.edu/view/aatm/devel/casa/"
# tar ball is made from the HOMEPAGE and running ./configure && make dist
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-libs/boost:=
	doc? ( app-doc/doxygen[dot] )"

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake
	use doc && doxygen doc/developer.doxy
}

src_install() {
	default
	use static-libs || prune_libtool_files --all
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r developer/html
	fi
}
