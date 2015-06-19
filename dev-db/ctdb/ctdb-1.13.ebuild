# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/ctdb/ctdb-1.13.ebuild,v 1.11 2014/08/10 19:58:22 slyfox Exp $

EAPI=4

inherit base eutils

DESCRIPTION="A cluster implementation of the TDB database used to store temporary data"
HOMEPAGE="http://ctdb.samba.org/"
# upstream is too sexy for releases, grab tags from:
#    http://git.samba.org/?p=ctdb.git;a=summary
SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="dev-libs/popt"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
)

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--localstatedir="${EPREFIX}/var/lib" \
		--with-logdir="${EPREFIX}/var/log/${PN}"
}

src_install() {
	default

	dohtml web/* doc/*.html
}
