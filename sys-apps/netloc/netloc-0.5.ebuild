# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib versionator

MY_PV=v$(get_version_component_range 1-2)

DESCRIPTION="Portable Network Locality (netloc)"
HOMEPAGE="https://www.open-mpi.org/projects/netloc/"
SRC_URI="https://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.gz"

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
