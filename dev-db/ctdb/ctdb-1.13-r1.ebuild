# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/ctdb/ctdb-1.13-r1.ebuild,v 1.12 2015/03/31 07:45:48 ago Exp $

EAPI=5

inherit eutils multilib-minimal

DESCRIPTION="A cluster implementation of the TDB database used to store temporary data"
HOMEPAGE="http://ctdb.samba.org/"
# upstream is too sexy for releases, grab tags from:
#    http://git.samba.org/?p=ctdb.git;a=summary
SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND=">=dev-libs/popt-1.16-r2[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
)

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user

	# custom, broken Makefile
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--localstatedir="${EPREFIX}/var/lib" \
		--with-logdir="${EPREFIX}/var/log/${PN}"
}

multilib_src_install_all() {
	einstalldocs
	dohtml web/* doc/*.html
}
