# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils linux-info user

DESCRIPTION="A highly available, distributed, and eventually consistent object/blob store"
HOMEPAGE="https://launchpad.net/swift"
SRC_URI="https://tarballs.openstack.org/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="proxy account container object +memcached"
REQUIRED_USE="|| ( proxy account container object )"

CDEPEND="
	>=dev-python/pbr-0.8.0[${PYTHON_USEDEP}]
	<dev-python/pbr-2.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"

RDEPEND="
	${CDEPEND}
	virtual/python-dnspython[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.17.4[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/netifaces-0.5[${PYTHON_USEDEP}]
	!~dev-python/netifaces-0.10.0[${PYTHON_USEDEP}]
	!~dev-python/netifaces-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/pastedeploy-1.3.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
	>=dev-python/PyECLib-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0[${PYTHON_USEDEP}]
	!~dev-python/cryptography-1.3.0[${PYTHON_USEDEP}]
	memcached? ( net-misc/memcached )
	net-misc/rsync[xattr]"

CONFIG_CHECK="~EXT3_FS_XATTR ~SQUASHFS_XATTR ~CIFS_XATTR ~JFFS2_FS_XATTR
~TMPFS_XATTR ~UBIFS_FS_XATTR ~EXT2_FS_XATTR ~REISERFS_FS_XATTR ~EXT4_FS_XATTR
~ZFS"

pkg_setup() {
	enewuser swift
	enewgroup swift
}

src_prepare() {
	sed -i 's/xattr/pyxattr/g' swift.egg-info/requires.txt || die
	sed -i 's/xattr/pyxattr/g' requirements.txt || die
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

src_test () {
	# https://bugs.launchpad.net/swift/+bug/1249727
	find . \( -name test_wsgi.py -o -name test_locale.py -o -name test_utils.py \) -delete || die
	SKIP_PIP_INSTALL=1 PBR_VERSION=0.6.0 sh .unittests || die
}

python_install() {
	distutils-r1_python_install
	keepdir /etc/swift
	insinto /etc/swift

	newins "etc/swift.conf-sample" "swift.conf"
	newins "etc/rsyncd.conf-sample" "rsyncd.conf"
	newins "etc/mime.types-sample" "mime.types-sample"
	newins "etc/memcache.conf-sample" "memcache.conf-sample"
	newins "etc/drive-audit.conf-sample" "drive-audit.conf-sample"
	newins "etc/dispersion.conf-sample" "dispersion.conf-sample"

	if use proxy; then
		newinitd "${FILESDIR}/swift-proxy.initd" "swift-proxy"
		newins "etc/proxy-server.conf-sample" "proxy-server.conf"
		if use memcached; then
			sed -i '/depend/a\
    need memcached' "${D}/etc/init.d/swift-proxy"
		fi
	fi
	if use account; then
		newinitd "${FILESDIR}/swift-account.initd" "swift-account"
		newins "etc/account-server.conf-sample" "account-server.conf"
	fi
	if use container; then
		newinitd "${FILESDIR}/swift-container.initd" "swift-container"
		newins "etc/container-server.conf-sample" "container-server.conf"
	fi
	if use object; then
		newinitd "${FILESDIR}/swift-object.initd" "swift-object"
		newins "etc/object-server.conf-sample" "object-server.conf"
		newins "etc/object-expirer.conf-sample" "object-expirer.conf"
	fi

	fowners swift:swift "/etc/swift" || die "fowners failed"
}

pkg_postinst() {
	elog "Openstack swift will default to using insecure http unless a"
	elog "certificate is created in /etc/swift/cert.crt and the associated key"
	elog "in /etc/swift/cert.key.  These can be created with the following:"
	elog "  * cd /etc/swift"
	elog "  * openssl req -new -x509 -nodes -out cert.crt -keyout cert.key"
}
