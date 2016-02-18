# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="
		git://github.com/ceph/ceph.git
		https://github.com/ceph/ceph.git"
	SRC_URI=""
else
	SRC_URI="http://ceph.com/download/${P}.tar.bz2"
fi
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

inherit check-reqs autotools eutils multilib python-single-r1 udev user readme.gentoo systemd versionator ${scm_eclass}

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="http://ceph.com/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="babeltrace cryptopp debug fuse gtk libatomic +libaio lttng +nss radosgw static-libs jemalloc tcmalloc xfs zfs"

CDEPEND="
	app-arch/snappy
	dev-libs/boost:=[threads]
	dev-libs/fcgi
	dev-libs/libaio
	dev-libs/libedit
	dev-libs/leveldb[snappy]
	nss? ( dev-libs/nss )
	cryptopp? ( dev-libs/crypto++ )
	sys-apps/keyutils
	sys-apps/util-linux
	dev-libs/libxml2
	babeltrace? ( dev-util/babeltrace )
	fuse? ( sys-fs/fuse )
	libatomic? ( dev-libs/libatomic_ops )
	xfs? ( sys-fs/xfsprogs )
	zfs? ( sys-fs/zfs )
	gtk? (
		x11-libs/gtk+:2
		dev-cpp/gtkmm:2.4
		gnome-base/librsvg
	)
	radosgw? (
		dev-libs/fcgi
		dev-libs/expat
		net-misc/curl
	)
	jemalloc? ( dev-libs/jemalloc )
	!jemalloc? ( dev-util/google-perftools )
	lttng? ( dev-util/lttng-ust )
	${PYTHON_DEPS}
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	sys-apps/hdparm
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	^^ ( nss cryptopp )
	?? ( jemalloc tcmalloc )
	"

STRIP_MASK="/usr/lib*/rados-classes/*"

PATCHES=(
	"${FILESDIR}"/${PN}-0.79-libzfs.patch
)

check-reqs_export_vars() {
	# check-reqs does not support use flags, and there is a lot of variability
	# in Ceph.
	# 16G     /var/tmp/portage/sys-cluster/ceph-9999-r1/work/ceph-9999
	# 6.7G    /var/tmp/portage/sys-cluster/ceph-9999-r1/image/usr
	# 23G     /var/tmp/portage/sys-cluster/ceph-9999-r1
	# Size requirements tested for Hammer & Jewel releases
	if use debug; then
		export CHECKREQS_DISK_BUILD="23G"
		export CHECKREQS_DISK_USR="7G"
	else
		export CHECKREQS_DISK_BUILD="9G"
		export CHECKREQS_DISK_USR="450M"
	fi

	export CHECKREQS_MEMORY="7G"
}

user_setup() {
	enewgroup ceph
	enewuser ceph -1 -1 /var/lib/ceph ceph
}

pkg_setup() {
	python_setup
	check-reqs_export_vars
	check-reqs_pkg_setup
	user_setup
}

src_prepare() {
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"

	epatch_user
	eautoreconf
}

pkg_pretend() {
	check-reqs_export_vars
	check-reqs_pkg_pretend
}

src_configure() {
	local myeconfargs=(
		--without-hadoop
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--includedir=/usr/include
		$(use_with debug)
		$(use_with fuse)
		$(use_with libaio)
		$(use_with libatomic libatomic-ops)
		$(use_with nss)
		$(use_with cryptopp)
		$(use_with radosgw)
		$(use_with gtk gtk2)
		$(use_enable static-libs static)
		$(use_with jemalloc)
		$(use_with xfs libxfs)
		$(use_with zfs libzfs)
		--without-kinetic
		--without-librocksdb
		$(use_with lttng )
		$(use_with babeltrace)
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	use jemalloc || \
		myeconfargs+=( $(usex tcmalloc " --with-tcmalloc" " --with-tcmalloc-minimal") )

	PYTHON="${EPYTHON}" \
		econf "${myeconfargs[@]}"
}

src_install() {
	default

	prune_libtool_files --all

	exeinto /usr/$(get_libdir)/ceph
	newexe src/init-ceph ceph_init.sh

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/ceph.logrotate ${PN}

	chmod 644 "${ED}"/usr/share/doc/${PF}/sample.*

	keepdir /var/lib/${PN}
	keepdir /var/lib/${PN}/tmp
	keepdir /var/log/${PN}/stat

	fowners ceph:ceph /var/lib/ceph

	newinitd "${FILESDIR}/rbdmap.initd" rbdmap
	newinitd "${FILESDIR}/${PN}.initd-r1" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r1" ${PN}

	systemd_install_serviced "${FILESDIR}/ceph-mds_at.service.conf" "ceph-mds@.service"
	systemd_install_serviced "${FILESDIR}/ceph-osd_at.service.conf" "ceph-osd@.service"
	systemd_install_serviced "${FILESDIR}/ceph-mon_at.service.conf" "ceph-mon@.service"

	python_fix_shebang \
		"${ED}"/usr/sbin/{ceph-disk,ceph-create-keys} \
		"${ED}"/usr/bin/{ceph,ceph-rest-api,ceph-detect-init,ceph-brag}

	#install udev rules
	udev_dorules udev/50-rbd.rules
	udev_dorules udev/95-ceph-osd.rules

	readme.gentoo_create_doc
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]] && ! version_is_at_least 9.0 ${REPLACING_VERSIONS}; then
		ewarn "You've upgraded ceph from old version, please fix the permission issue"
		ewarn "Please refer section 4) in README.gentoo doc for detail info"
		ewarn "  bzless /usr/share/doc/${P}/README.gentoo.bz2"
	fi
}
