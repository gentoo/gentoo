# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/ganeti/ganeti-2.4.5-r1.ebuild,v 1.7 2014/07/02 23:57:25 chutzpah Exp $

EAPI=4

inherit eutils confutils bash-completion-r1

MY_PV="${PV/_rc/~rc}"
#MY_PV="${PV/_beta/~beta}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Ganeti is a virtual server management software tool"
HOMEPAGE="http://code.google.com/p/ganeti/"
SRC_URI="http://ganeti.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="kvm xen drbd +filestorage syslog ipv6"

S="${WORKDIR}/${MY_P}"

DEPEND="xen? ( >=app-emulation/xen-3.0 )
	kvm? ( app-emulation/qemu )
	drbd? ( >=sys-cluster/drbd-8.3 )
	ipv6? ( net-misc/ndisc6 )
	dev-libs/openssl
	dev-python/paramiko
	dev-python/pyopenssl
	dev-python/pyparsing
	dev-python/pycurl
	dev-python/pyinotify
	dev-python/simplejson
	net-analyzer/arping
	net-misc/bridge-utils
	net-misc/curl[ssl]
	net-misc/openssh
	net-misc/socat
	sys-apps/iproute2
	sys-fs/lvm2
	>=sys-apps/baselayout-2.0"
RDEPEND="${DEPEND}
	!<app-emulation/ganeti-htools-0.3"

pkg_setup () {
	confutils_require_any kvm xen
}

src_prepare () {
	epatch "${FILESDIR}/${PN}-fix-start-stop.patch"
}

src_configure () {
	local myconf
	if use filestorage ; then
		myconf="--with-file-storage-dir=/var/lib/ganeti-storage/file"
	else
		myconf="--with-file-storage-dir=no"
	fi
	if use kvm && [ -f /usr/bin/qemu-kvm ] ; then
		myconf="--with-kvm-path=/usr/bin/qemu-kvm"
	fi
	econf --localstatedir=/var \
		--docdir=/usr/share/doc/${P} \
		--with-ssh-initscript=/etc/init.d/sshd \
		--with-export-dir=/var/lib/ganeti-storage/export \
		--with-os-search-path=/usr/share/ganeti/os \
		$(use_enable syslog) \
		${myconf}
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}"/ganeti-2.1.initd ganeti
	newconfd "${FILESDIR}"/ganeti.confd ganeti
	use kvm && newinitd "${FILESDIR}"/ganeti-kvm-poweroff.initd ganeti-kvm-poweroff
	use kvm && newconfd "${FILESDIR}"/ganeti-kvm-poweroff.confd ganeti-kvm-poweroff
	newbashcomp doc/examples/bash_completion ganeti
	dodoc INSTALL UPGRADE NEWS README doc/*.rst
	rm -rf "${D}"/usr/share/doc/ganeti
	docinto examples
	#dodoc doc/examples/{basic-oob,ganeti.cron,gnt-config-backup}
	dodoc doc/examples/{ganeti.cron,gnt-config-backup}
	docinto examples/hooks
	dodoc doc/examples/hooks/{ipsec,ethers}

	keepdir /var/{lib,log,run}/ganeti/
	keepdir /usr/share/ganeti/os/
	keepdir /var/lib/ganeti-storage/{export,file}/
}
