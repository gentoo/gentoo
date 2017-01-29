# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_PN=firejail
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Security sandbox for any type of processes; LTS branch"
HOMEPAGE="https://firejail.wordpress.com/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="+seccomp"

DEPEND="!sys-apps/firejail"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find -name Makefile.in -exec sed -i -r \
			-e '/^\tinstall .*COPYING /d' \
			-e '/CFLAGS/s: (-O2|-ggdb) : :g' \
			-e '1iCC=@CC@' {} + || die
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable seccomp)
}
