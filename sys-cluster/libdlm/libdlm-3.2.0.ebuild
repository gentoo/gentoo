# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib toolchain-funcs versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2-3)"

DESCRIPTION="General-purpose Distributed Lock Manager Library"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/c/l/cluster/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"
IUSE="static-libs"

RDEPEND="
	!sys-cluster/dlm-headers
	!sys-cluster/dlm-kernel
	!sys-cluster/dlm-lib"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.24"

S="${WORKDIR}/${MY_P}/dlm"

src_prepare() {
	sed -i \
		-e "s|/lib|/$(get_libdir)|g" \
		"${WORKDIR}/${MY_P}/make/install.mk" || die "sed failed"
}

src_configure() {
	cd "${WORKDIR}/${MY_P}"
	./configure \
		--cc=$(tc-getCC) \
		--cflags="-Wall" \
		--libdir=/usr/$(get_libdir) \
		--disable_kernel_check \
		--kernel_src=/usr/ \
		--somajor="$MAJ_PV" \
		--sominor="$MIN_PV" \
		--dlmlibdir=/usr/$(get_libdir) \
		--dlmincdir=/usr/include \
		--dlmcontrollibdir=/usr/$(get_libdir) \
		--dlmcontrolincdir=/usr/include \
	    || die "configure problem"
}

src_compile() {
	for i in libdlm libdlmcontrol; do
		emake -C ${i}
	done
}

src_install() {
	for i in libdlm libdlmcontrol; do
		emake DESTDIR="${D}" -C ${i} install
	done
	mv "${D}"/$(get_libdir) "${D}"/lib
	use static-libs || rm -f "${D}"/usr/lib*/*.a
	doman man/libdlm.3
	dodoc doc/{libdlm.txt,example.c,user-dlm-overview.txt}
}
