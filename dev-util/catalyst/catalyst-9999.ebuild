# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == *9999* ]]; then
	SRC_ECLASS="git-r3"
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/catalyst.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://gitweb.gentoo.org/proj/catalyst.git/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 ${SRC_ECLASS}

DESCRIPTION="Release metatool used for creating releases based on Gentoo Linux"
HOMEPAGE="https://wiki.gentoo.org/wiki/Catalyst"

LICENSE="GPL-2"
SLOT="0"
IUSE="ccache doc +iso kernel_linux system-bootloader"

COMMON_DEPEND="
	>=dev-python/snakeoil-0.6.5[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"
DEPEND="
	${COMMON_DEPEND}
	app-text/asciidoc
"
RDEPEND="
	${COMMON_DEPEND}
	>=dev-python/pydecomp-0.3[${PYTHON_USEDEP}]
	app-arch/lbzip2
	app-arch/tar[xattr]
	dev-vcs/git
	sys-fs/dosfstools
	sys-fs/squashfs-tools-ng
	ccache? ( dev-util/ccache )

	iso? (
		virtual/cdrtools

		alpha? (
			dev-libs/libisoburn
		)
		ia64?  (
			dev-libs/libisoburn
			sys-boot/grub[grub_platforms_efi-64]
			sys-fs/mtools
		)
		ppc?   (
			dev-libs/libisoburn
			sys-boot/grub:2[grub_platforms_ieee1275]
		)
		ppc64? (
			dev-libs/libisoburn
			sys-boot/grub:2[grub_platforms_ieee1275]
		)
		sparc? (
			dev-libs/libisoburn
			sys-boot/grub:2[grub_platforms_ieee1275]
		)
	)

	amd64? ( >=sys-boot/syslinux-3.72 )
	x86?   ( >=sys-boot/syslinux-3.72 )
"
PDEPEND="
	system-bootloader? (
		>=sys-apps/memtest86+-5.01-r4
		sys-boot/grub:2
		sys-boot/shim
		sys-boot/syslinux

		amd64? ( sys-boot/grub[grub_platforms_efi-32,grub_platforms_efi-64] )
		x86?   ( sys-boot/grub[grub_platforms_efi-32] )
	)
"

python_prepare_all() {
	python_setup
	echo VERSION="${PV}" "${PYTHON}" setup.py set_version
	VERSION="${PV}" "${PYTHON}" setup.py set_version || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# build the man pages and docs
	emake
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		dodoc files/HOWTO.html files/docbook-xsl.css
	fi
}
