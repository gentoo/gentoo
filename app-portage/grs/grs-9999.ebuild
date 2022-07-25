# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{8,9,10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 linux-info

ISO="ISO-1.tar.gz"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/grss.git"
	SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${ISO}"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~blueness/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~blueness/${PN}/${ISO}"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Suite to build Gentoo Reference Systems"
HOMEPAGE="https://dev.gentoo.org/~blueness/grs"

LICENSE="GPL-2"
SLOT="0"
IUSE="server"

DEPEND=""
RDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
	server? (
		app-arch/tar[xattr]
		app-cdr/cdrtools
		app-crypt/md5deep
		dev-libs/libcgroup
		dev-vcs/git
		net-misc/rsync
		sys-fs/squashfs-tools
		sys-kernel/genkernel
	)"

pkg_setup() {
	if use server; then
		local CONFIG_CHECK="~CGROUPS"
		local ERROR_CGROUPS="WARNING: grsrun requires CONFIG_CGROUPS enabled in the kernel."
		linux-info_pkg_setup
	fi
}

src_install() {
	distutils-r1_src_install
	echo "CONFIG_PROTECT=\"/etc/grs/systems.conf\"" > "${T}"/20grs
	doenvd "${T}"/20grs
	if use server; then
		mkdir "${D}"/usr/share/${PN}
		cp "${DISTDIR}"/${ISO} "${D}"/usr/share/${PN}
	else
		rm "${D}"/usr/bin/grsrun
	fi
}
