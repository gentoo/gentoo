# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

MY_P="${P/mhonarc-gentoo/MHonArc}"

DESCRIPTION="Perl Mail-to-HTML Converter, Gentoo fork"
HOMEPAGE="https://www.mhonarc.org/"
SRC_URI="https://www.mhonarc.org/release/MHonArc/tar/MHonArc-${PV}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!net-mail/mhonarc"

PATCHES=( "${FILESDIR}"/${P}-archives-gentoo.patch )

src_install() {
	sed -e "s|-prefix |-docpath '${ED}/usr/share/doc/${PF}' -prefix '${ED}'|g" -i Makefile || die "sed on Makefile failed"
	sed -e "s|installsitelib|installvendorlib|g" -i install.me || die "sed on install.me failed"

	perl-module_src_install
}
