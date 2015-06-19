# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/rgmanager/rgmanager-3.1.5.ebuild,v 1.1 2011/09/14 10:47:36 ultrabug Exp $

EAPI=4

inherit eutils multilib versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2-3)"

DESCRIPTION="Clustered resource group manager"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/c/l/cluster/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

DEPEND="~sys-cluster/libcman-${PV}
	~sys-cluster/liblogthread-${PV}
	~sys-cluster/libccs-${PV}
	~sys-cluster/libdlm-${PV}
	dev-libs/libxml2
	=sys-libs/slang-2*
	dbus? ( sys-apps/dbus )"
RDEPEND="${DEPEND}
	~sys-cluster/cman-${PV}"

S=${WORKDIR}/${MY_P}/${PN}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix_libxml2.patch"
}

src_configure() {
	local myopts=""
	use dbus || myopts="--disable_dbus"
	cd "${WORKDIR}"/${MY_P}
	./configure \
		--cc="$(tc-getCC)" \
		--cflags="-Wall" \
		--libdir=/usr/$(get_libdir) \
		--disable_kernel_check \
		--somajor="$MAJ_PV" \
		--sominor="$MIN_PV" \
		--dlmlibdir=/usr/$(get_libdir) \
		--dlmincdir=/usr/include \
		--cmanlibdir=/usr/$(get_libdir) \
		--cmanincdir=/usr/include \
		${myopts} \
		|| die "configure problem"
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
