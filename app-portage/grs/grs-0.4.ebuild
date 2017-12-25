# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/grss.git"
	inherit git-r3
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

src_install() {
	distutils-r1_src_install
	echo "CONFIG_PROTECT=\"/etc/grs/systems.conf\"" > "${T}"/20grs
	doenvd "${T}"/20grs
}
