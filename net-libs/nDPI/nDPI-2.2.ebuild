# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils multilib versionator

DESCRIPTION="Open Source Deep Packet Inspection Software Toolkit"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="dev-libs/json-c:=
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s/@NDPI_MAJOR@/$(get_version_component_range 1)/g;s/@NDPI_MINOR@/$(get_version_component_range 2)/g;s/@NDPI_PATCH@/$(get_version_component_range 3)/g;s/@NDPI_VERSION_SHORT@/${PV}/g" < "${S}/configure.seed" > "${S}/configure.ac" || die

	mv "${S}/src/lib/third_party/include/libcache.h" "${S}/src/include"
	epatch "${FILESDIR}/${P}-libcache-include.patch"

	default
	eautoreconf
}

src_install() {
	default
	if ! use static-libs; then
		rm "${D}"/usr/$(get_libdir)/lib${PN,,}.a || die
	fi
	prune_libtool_files
}
