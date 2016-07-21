# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit linux-info multilib toolchain-funcs versionator

CLUSTER_RELEASE="${PV}"
MY_P="cluster-${CLUSTER_RELEASE}"

MAJ_PV="$(get_major_version)"
MIN_PV="$(get_version_component_range 2-3)"

DESCRIPTION="Cluster Manager"
HOMEPAGE="https://fedorahosted.org/cluster/wiki/HomePage"
SRC_URI="https://fedorahosted.org/releases/c/l/cluster/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="dbus ldap"

RDEPEND="dev-libs/libxml2
	dev-libs/libxslt
	dbus? ( sys-apps/dbus )
	ldap? ( net-nds/openldap )
	sys-cluster/corosync
	sys-cluster/openais
	~sys-cluster/libccs-${PV}
	~sys-cluster/libfence-${PV}
	~sys-cluster/libcman-${PV}
	~sys-cluster/libdlm-${PV}
	~sys-cluster/liblogthread-${PV}
	!sys-cluster/dlm
"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.24"

S="${WORKDIR}/${MY_P}"

# TODO:
# * Gentoo'ise the init script

src_configure() {
	# cluster libs have their own separate packages
	sed -i -e 's|lib||' "${S}/cman/Makefile" || die
	sed -i -e 's|liblogthread||' "${S}/common/Makefile" || die
	sed -i -e 's|libs||' "${S}/config/Makefile" || die
	sed -i -e 's|libdlm libdlmcontrol||' "${S}/dlm/Makefile" || die
	sed -i -e 's|libfence libfenced||' "${S}/fence/Makefile" || die
	sed -i -e 's|fence/libfenced||' "${S}/Makefile" || die

	sed -i \
		-e 's|\(^all:.*\)depends |\1|' \
		config/tools/ccs_tool/Makefile \
		fence/fence{d,_node,_tool}/Makefile \
		cman/{cman_tool,daemon,tests,qdisk,notifyd}/Makefile \
		dlm/{tool,tests/usertest}/Makefile \
		|| die "sed failed"

	if ! use ldap ; then
		sed -i -e 's|ldap||' config/plugins/Makefile || die "sed failed"
	fi
	local myopts=""
	use dbus || myopts="--disable_dbus"
	./configure \
		--cc=$(tc-getCC) \
		--cflags="-Wall" \
		--libdir=/usr/$(get_libdir) \
		--disable_kernel_check \
		--kernel_src=${KERNEL_DIR} \
		--somajor="$MAJ_PV" \
		--sominor="$MIN_PV" \
		--without_rgmanager \
		--without_bindings \
		${myopts} \
		|| die "configure problem"
}

src_install() {
	emake DESTDIR="${D}" install

	# we have to create it in the init.d script anyway
	rmdir "${D}"/var/run/{cluster,}

	keepdir /var/{lib,log}/cluster
	keepdir /etc/cluster/cman-notify.d

	rm -rf "${D}/usr/share/doc"
	dodoc \
		doc/{usage.txt,cman_notify_template.sh} \
		config/plugins/ldap/*.ldif
	dohtml doc/*.html

	# lib-specific man pages are provided by the corresponding packages
	rm "${D}/usr/share/man/man3/libdlm.3"

	newinitd "${FILESDIR}/${PN}.initd-3.1.5-r1" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}
