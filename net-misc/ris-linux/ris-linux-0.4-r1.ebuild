# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="BINL server to doing Windows(r) RIS"
HOMEPAGE="http://oss.netfarm.it/guides/pxe.php"
SRC_URI="http://oss.netfarm.it/guides/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	|| ( net-ftp/atftp net-ftp/tftp-hpa )
	net-misc/dhcp
	net-fs/samba
	sys-boot/syslinux"

python_prepare_all(){
	sed "s:VERSION:${PV}:" "${FILESDIR}"/setup.py > "${S}"/setup.py
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	newinitd "${FILESDIR}"/binlsrv.initd binlsrv
	newconfd "${FILESDIR}"/binlsrv.confd binlsrv
}
