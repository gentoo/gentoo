# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vov/vov-2.0.0.ebuild,v 1.4 2014/08/06 06:44:38 patrick Exp $

inherit flag-o-matic

DESCRIPTION="vov (Vov's Obsessive Von-Neumann) is a tool that emulates the behavior of a Von-Neumann machine"
HOMEPAGE="http://home.gna.org/vov/"
SRC_URI="http://download.gna.org/vov/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="debug gprof"

RDEPEND=""
DEPEND=">=sys-devel/flex-2.5.33-r3
	>=sys-apps/sed-4.1.5"

src_unpack()
{
	unpack ${A}

	# do no install redundant documentation
	cd "${S}"
	sed -i 's/src scripts docs/src scripts/' "${S}/Makefile.in"
}

src_compile()
{
	local fp_support=""

	if use gprof; then
		filter-flags "-fomit-frame-pointer"
		fp_support="--enable-frame-pointer"
	fi

	econf                       \
		`use_enable gprof`      \
		`use_enable debug`      \
		${fp_support}           \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install()
{
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README NEWS
	doman docs/vov.1
}
