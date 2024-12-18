# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 git-r3 optfeature shell-completion

DESCRIPTION="Python based initramfs generator with TOML defintions"
HOMEPAGE="https://github.com/desultory/ugrd"
EGIT_REPO_URI="https://github.com/desultory/${PN}"

LICENSE="GPL-2"
SLOT="0"
RESTRICT="test"
PROPERTIES="test_privileged"

RDEPEND="
	app-misc/pax-utils
	>=dev-python/zenlib-9999[${PYTHON_USEDEP}]
	>=dev-python/pycpio-9999[${PYTHON_USEDEP}]
	sys-apps/pciutils
"

BDEPEND="
	test? (
		sys-fs/btrfs-progs
		sys-fs/xfsprogs
		sys-fs/cryptsetup
		amd64? ( app-emulation/qemu[qemu_softmmu_targets_x86_64] )
		arm64? ( app-emulation/qemu[qemu_softmmu_targets_aarch64] )
	)
"

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
	optfeature "ugrd.fs.lvm support" sys-fs/lvm2[lvm]
	optfeature "ugrd.fs.mdraid support" sys-fs/mdadm
	optfeature "ugrd.base.plymouth support" sys-boot/plymouth
}

distutils_enable_tests unittest

src_test() {
	addwrite /dev/kvm
	distutils-r1_src_test
}

python_test() {
	eunittest tests/
}
