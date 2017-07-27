# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit check-reqs autotools eutils python-r1 udev user \
	readme.gentoo-r1 systemd versionator flag-o-matic

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="
		git://github.com/ceph/ceph.git
		https://github.com/ceph/ceph.git"
	SRC_URI=""
else
	SRC_URI="http://download.ceph.com/tarballs/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="http://ceph.com/"

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="babeltrace cephfs cryptopp debug fuse gtk jemalloc ldap +libaio"
IUSE+=" libatomic lttng +nss +radosgw static-libs +tcmalloc test xfs zfs"

# unbundling code commented out pending bugs 584056 and 584058
#>=dev-libs/jerasure-2.0.0-r1
#>=dev-libs/gf-complete-2.0.0
COMMON_DEPEND="
	app-arch/snappy
	app-arch/lz4:=
	app-arch/bzip2
	dev-libs/boost:=[threads]
	dev-libs/libaio
	dev-libs/leveldb[snappy]
	nss? ( dev-libs/nss )
	libatomic? ( dev-libs/libatomic_ops )
	cryptopp? ( dev-libs/crypto++:= )
	sys-apps/keyutils
	sys-apps/util-linux
	dev-libs/libxml2
	radosgw? ( dev-libs/fcgi )
	ldap? ( net-nds/openldap )
	babeltrace? ( dev-util/babeltrace )
	fuse? ( sys-fs/fuse )
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
DEPEND="${COMMON_DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	app-arch/cpio
	virtual/pkgconfig
	dev-python/sphinx
	test? (
		sys-fs/btrfs-progs
		sys-apps/grep[pcre]
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
	)"
RDEPEND="${COMMON_DEPEND}
	sys-apps/hdparm
	sys-block/parted
	sys-fs/cryptsetup
	sys-apps/gptfdisk
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	"
REQUIRED_USE="
	$(python_gen_useflags 'python2*')
	${PYTHON_REQUIRED_USE}
	^^ ( nss cryptopp )
	?? ( jemalloc tcmalloc )
	"

# work around bug in ceph compilation (rgw/ceph_dencoder-rgw_dencoder.o... undefined reference to `vtable for RGWZoneGroup')
REQUIRED_USE+=" radosgw"

RESTRICT="test? ( userpriv )"

# distribution tarball does not include everything needed for tests
RESTRICT+=" test"

STRIP_MASK="/usr/lib*/rados-classes/*"

UNBUNDLE_LIBS=(
	src/erasure-code/jerasure/jerasure
	src/erasure-code/jerasure/gf-complete
)

PATCHES=(
	"${FILESDIR}/ceph-10.2.0-dont-use-virtualenvs.patch"
	#"${FILESDIR}/ceph-10.2.1-unbundle-jerasure.patch"
	"${FILESDIR}/${PN}-10.2.1-libzfs.patch"
	"${FILESDIR}/${PN}-10.2.3-build-without-openldap.patch"
	"${FILESDIR}/${PN}-10.2.5-Make-RBD-Python-bindings-compatible-with-Python-3.patch"
	"${FILESDIR}/${PN}-10.2.5-Make-CephFS-bindings-and-tests-compatible-with-Python-3.patch"
	"${FILESDIR}/${PN}-10.2.6-radosgw-swift-clean-up-flush-newline-behavior.patch"
)

check-reqs_export_vars() {
	if use debug; then
		CHECKREQS_DISK_BUILD="23G"
		CHECKREQS_DISK_USR="7G"
	elif use amd64; then
		CHECKREQS_DISK_BUILD="12G"
		CHECKREQS_DISK_USR="450M"
	else
		CHECKREQS_DISK_BUILD="1400M"
		CHECKREQS_DISK_USR="450M"
	fi

	export CHECKREQS_DISK_BUILD CHECKREQS_DISK_USR
}

user_setup() {
	enewgroup ceph ${CEPH_GID}
	enewuser ceph "${CEPH_UID:--1}" -1 /var/lib/ceph ceph
}

emake_python_bindings() {
	local action="${1}" params binding module
	shift
	params=("${@}")

	__emake_python_bindings_do_impl() {
		ceph_run_econf "${EPYTHON}"
		emake "${params[@]}" PYTHON="${EPYTHON}" "${binding}-pybind-${action}"

		# these don't work and aren't needed on python3
		if [[ ${EBUILD_PHASE} == install ]]; then
			for module in "${S}"/src/pybind/*.py; do
				module_basename="$(basename "${module}")"
				if [[ ${module_basename} == ceph_volume_client.py ]] && ! use cephfs; then
					continue
				elif [[ ! -e "${ED}/$(python_get_sitedir)/${module_basename}" ]]; then
					python_domodule ${module}
				fi
			done
		fi
	}

	pushd "${S}/src"
	for binding in rados rbd $(use cephfs && echo cephfs); do
		python_foreach_impl __emake_python_bindings_do_impl
	done
	popd

	unset __emake_python_bindings_do_impl
}

pkg_pretend() {
	check-reqs_export_vars
	check-reqs_pkg_pretend
}

pkg_setup() {
	python_setup
	check-reqs_export_vars
	check-reqs_pkg_setup
	user_setup
}

src_prepare() {
	default

	# remove tests that need root access
	rm src/test/cli/ceph-authtool/cap*.t

	#rm -rf "${UNBUNDLE_LIBS[@]}"

	append-flags -fPIC
	eautoreconf
}

src_configure() {
	ECONFARGS=(
		--without-hadoop
		--includedir=/usr/include
		$(use_with cephfs)
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
		$(use_with lttng )
		$(use_with babeltrace)
		$(use_with ldap openldap)
		$(use jemalloc || usex tcmalloc " --with-tcmalloc" " --with-tcmalloc-minimal")
		--with-mon
		--with-eventfd
		--with-cython
		--without-kinetic
		--without-librocksdb
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	# we can only use python2.7 for building at the moment
	ceph_run_econf "python2*"
}

ceph_run_econf() {
	[[ -z ${ECONFARGS} ]] && die "called ${FUNCNAME[0]} with ECONFARGS unset"
	[[ -z ${1} ]] && die "called ${FUNCNAME[0]} without passing python implementation"

	pushd "${S}" >/dev/null || die
	#
	# This generates a QA warning about running econf in src_compile
	# and src_install. Unfortunately the only other way to do this would
	# involve building all of for each python implementation times, which
	# wastes a _lot_ of CPU time and disk space. This hack will no longer
	# be needed with >=ceph-11.2.
	#
	python_setup "${1}"
	econf "${ECONFARGS[@]}"

	popd >/dev/null || die
}

src_compile() {
	emake
	emake_python_bindings all

	use test && emake check-local
}

src_test() {
	make check || die "make check failed"
}

src_install() {
	default
	emake_python_bindings install-exec "DESTDIR=\"${D}\""

	prune_libtool_files --all

	exeinto /usr/$(get_libdir)/ceph
	newexe src/init-ceph ceph_init.sh

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/ceph.logrotate ${PN}

	keepdir /var/lib/${PN}{,/tmp} /var/log/${PN}/stat

	fowners -R ceph:ceph /var/lib/ceph /var/log/ceph

	newinitd "${FILESDIR}/rbdmap.initd" rbdmap
	newinitd "${FILESDIR}/${PN}.initd-r4" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r2" ${PN}

	systemd_install_serviced "${FILESDIR}/ceph-mds_at.service.conf" "ceph-mds@.service"
	systemd_install_serviced "${FILESDIR}/ceph-osd_at.service.conf" "ceph-osd@.service"

	udev_dorules udev/*.rules

	readme.gentoo_create_doc

	python_setup 'python2*'
	python_fix_shebang "${ED}"/usr/{,s}bin/

	# python_fix_shebang apparently is not idempotent
	sed -i -r  's:(/usr/lib/python-exec/python[0-9]\.[0-9]/python)[0-9]\.[0-9]:\1:' \
		"${ED}"/usr/{sbin/ceph-disk,bin/ceph-detect-init} || die "sed failed"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
