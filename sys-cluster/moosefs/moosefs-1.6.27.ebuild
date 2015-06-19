# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/moosefs/moosefs-1.6.27.ebuild,v 1.3 2015/04/08 18:25:44 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 user

MY_P="mfs-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A filesystem for highly reliable petabyte storage"
HOMEPAGE="http://www.moosefs.org/"
SRC_URI="http://pro.hit.gemius.pl/hitredir/id=.WCbG2t.7Ln5k1s3Q9xPg8cPfX.wVMc5kyXfrKcJTDH.c7/url=moosefs.org/tl_files/mfscode/${MY_P}-1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cgi +fuse static-libs"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	cgi? ( dev-lang/python )
	fuse? ( >=sys-fs/fuse-2.6 )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup mfs
	enewuser mfs -1 -1 -1 mfs
	python-single-r1_pkg_setup
}

src_prepare() {
	# rename dist config files
	sed -i 's@\.cfg\.dist@\.cfg@g' mfsdata/Makefile.in || die
}

src_configure() {
	local myopts=""
	use fuse || myopts="--disable-mfsmount"
	econf \
		--sysconfdir=/etc/mfs \
		--with-default-user=mfs \
		--with-default-group=mfs \
		$(use_enable cgi mfscgi) \
		$(use_enable cgi mfscgiserv) \
		$(use_enable static-libs static) \
		${myopts}
}

src_install() {
	emake DESTDIR="${D}" install

	newinitd "${FILESDIR}/mfs.initd-r1" mfs
	newconfd "${FILESDIR}/mfs.confd" mfs
	if use cgi; then
		python_fix_shebang "${D}"/usr/sbin/mfscgiserv
		newinitd "${FILESDIR}/mfscgiserver.initd-r1" mfscgiserver
		newconfd "${FILESDIR}/mfscgiserver.confd" mfscgiserver
	fi

	chown -R mfs:mfs "${D}/var/lib/mfs" || die
	chmod 750 "${D}/var/lib/mfs" || die
}
