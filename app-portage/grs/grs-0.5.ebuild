# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1 linux-info

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/grss.git"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${P}.tar.gz"
	KEYWORDS="amd64"
fi

DESCRIPTION="Suite to build Gentoo Reference Systems"
HOMEPAGE="https://dev.gentoo.org/~blueness/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	app-arch/tar[xattr]
	app-crypt/md5deep
	dev-libs/libcgroup
	dev-vcs/git
	net-misc/rsync
	sys-apps/portage
	sys-fs/squashfs-tools
	virtual/cdrtools
	|| (
		sys-kernel/genkernel
		sys-kernel/genkernel-next
	)"

pkg_setup() {
	local CONFIG_CHECK="~CGROUPS"
	local ERROR_CGROUPS="WARNING: grsrun requires CONFIG_CGROUPS enabled in the kernel."
	linux-info_pkg_setup
}

src_install() {
	distutils-r1_src_install
	echo "CONFIG_PROTECT=\"/etc/grs/systems.conf\"" > "${T}"/20grs
	doenvd "${T}"/20grs
}
