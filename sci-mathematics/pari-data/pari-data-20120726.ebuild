# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Data sets for pari"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"

for p in elldata galdata galpol seadata nftables; do
	SRC_URI="${SRC_URI} http://pari.math.u-bordeaux.fr/pub/pari/packages/${p}.tgz -> ${p}-${PV}.tgz"
done

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="!<sci-libs/pari-2.5.0-r1"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
	insinto /usr/share/pari
	doins -r data/* nftables
}
