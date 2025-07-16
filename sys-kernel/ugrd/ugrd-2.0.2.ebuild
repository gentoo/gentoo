# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 optfeature shell-completion

DESCRIPTION="Python based POSIX initramfs generator with TOML definitions"
HOMEPAGE="https://github.com/desultory/ugrd"
SRC_URI="https://github.com/desultory/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="test"
PROPERTIES="test_privileged"

RDEPEND="
	app-misc/pax-utils
	sys-devel/bc
	>=dev-python/zenlib-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/pycpio-1.5.2[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		sys-fs/cryptsetup
		sys-fs/btrfs-progs
		sys-fs/e2fsprogs
		sys-fs/f2fs-tools
		sys-fs/xfsprogs
		sys-fs/squashfs-tools
		dev-python/zstandard
		amd64? ( app-emulation/qemu[qemu_softmmu_targets_x86_64] )
		arm64? ( app-emulation/qemu[qemu_softmmu_targets_aarch64] )
	)
"

distutils_enable_tests unittest

src_test() {
	addwrite /dev/kvm
	distutils-r1_src_test
}

python_test() {
	eunittest tests/
}

python_install_all() {
	# Call the distutils-r1_python_install_all function
	distutils-r1_python_install_all
	# Install the example config into /etc/ugrd/config.toml
	# Do not overwrite an existing config
	insinto /etc/ugrd
	newins examples/example.toml config.toml

	# Install the kernel preinst.d hook
	exeinto /usr/lib/kernel/preinst.d
	doexe hooks/installkernel/52-ugrd.install
	exeinto /usr/lib/kernel/install.d
	doexe hooks/kernel-install/52-ugrd.install

	dobashcomp completion/ugrd  # Install bash autocomplete script
	dozshcomp completion/_ugrd  # Install zsh autocomplete script
}

pkg_postinst() {
	optfeature "ugrd.crypto.cryptsetup support" sys-fs/cryptsetup
	optfeature "ugrd.fs.btrfs support" sys-fs/btrfs-progs
	optfeature "ugrd.crypto.gpg support" app-crypt/gnupg
	optfeature "ugrd.fs.ext4 support" sys-fs/e2fsprogs
	optfeature "ugrd.fs.f2s support" sys-fs/f2fs-tools
	optfeature "ugrd.fs.lvm support" sys-fs/lvm2[lvm]
	optfeature "ugrd.fs.zfs support" sys-fs/zfs
	optfeature "ugrd.fs.mdraid support" sys-fs/mdadm
	optfeature "ugrd.base.plymouth support" sys-boot/plymouth
	optfeature "ZSTD compression support" dev-python/zstandard
}
