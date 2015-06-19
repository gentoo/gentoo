# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/netloc/netloc-0.5.ebuild,v 1.1 2014/04/08 09:04:15 alexxy Exp $

EAPI=5

inherit multilib versionator

MY_PV=v$(get_version_component_range 1-2)

DESCRIPTION="Portable Network Locality (netloc)"
HOMEPAGE="http://www.open-mpi.org/projects/netloc/"
SRC_URI="http://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/jansson
	sys-apps/hwloc"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-jansson="${EPREFIX}/usr" \
		--with-hwloc="${EPREFIX}/usr"
}
