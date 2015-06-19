# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/ceph/ceph-9999.ebuild,v 1.16 2015/05/16 12:20:13 blueness Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="
		git://github.com/ceph/ceph.git
		https://github.com/ceph/ceph.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://ceph.com/download/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
fi

inherit autotools eutils multilib python-any-r1 udev readme.gentoo ${scm_eclass}

DESCRIPTION="Ceph distributed filesystem"
HOMEPAGE="http://ceph.com/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="cryptopp debug fuse gtk libatomic +libaio +nss radosgw static-libs tcmalloc xfs zfs"

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
	tcmalloc? ( dev-util/google-perftools )
	$(python_gen_any_dep '
	' )
	${PYTHON_DEPS}
	"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	sys-apps/hdparm
	$(python_gen_any_dep '
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	' )"
REQUIRED_USE="
	^^ ( nss cryptopp )
	"

STRIP_MASK="/usr/lib*/rados-classes/*"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	[[ ${PATCHES[@]} ]] && epatch "${PATCHES[@]}"

	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		--without-hadoop \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--includedir=/usr/include \
		$(use_with debug) \
		$(use_with fuse) \
		$(use_with libaio) \
		$(use_with libatomic libatomic-ops) \
		$(use_with nss) \
		$(use_with cryptopp) \
		$(use_with radosgw) \
		$(use_with gtk gtk2) \
		$(use_enable static-libs static) \
		$(use_with tcmalloc) \
		$(use_with xfs libxfs) \
		$(use_with zfs libzfs)
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

	newinitd "${FILESDIR}/${PN}.initd-r1" ${PN}
	newconfd "${FILESDIR}/${PN}.confd-r1" ${PN}

	python_fix_shebang \
		"${ED}"/usr/sbin/{ceph-disk,ceph-create-keys} \
		"${ED}"/usr/bin/{ceph,ceph-rest-api}

	#install udev rules
	udev_dorules udev/50-rbd.rules
	udev_dorules udev/95-ceph-osd.rules

	readme.gentoo_create_doc
}
