# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit perl-module

DESCRIPTION="Perl Mail-to-HTML Converter, Gentoo fork"
HOMEPAGE="http://www.mhonarc.org/"
LICENSE="GPL-2"
SRC_URI="http://www.mhonarc.org/release/MHonArc/tar/MHonArc-${PV}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!net-mail/mhonarc"

MY_P="${P/mhonarc-gentoo/MHonArc}"
S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-archives-gentoo.patch" )

src_install() {
	sed -e "s|-prefix |-docpath '${D}/usr/share/doc/${PF}' -prefix '${D}'|g" -i Makefile || die "sed on Makefile failed"
	sed -e "s|installsitelib|installvendorlib|g" -i install.me || die "sed on install.me failed"

	perl-module_src_install
}
