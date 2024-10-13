# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
inherit distutils-r1 git-r3 optfeature shell-completion

DESCRIPTION="Python based initramfs generator with TOML defintions"
HOMEPAGE="https://github.com/desultory/ugrd"
EGIT_REPO_URI="https://github.com/desultory/${PN}"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	app-misc/pax-utils
	>=dev-python/zenlib-9999[${PYTHON_USEDEP}]
	>=dev-python/pycpio-9999[${PYTHON_USEDEP}]
	sys-apps/pciutils
"

BDEPEND="
	test? (
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
	if [[ ! -w '/dev/kvm' ]]; then
		ewarn "Skipping tests: Cannot write to /dev/kvm."
		return 1
	fi
	if [[ ! -r "$(command -v mount)" ]]; then
		ewarn "Cannot read the mount binary, tests may fail until"
		ewarn "util-linux is re-emerged without the sfperms feature."
	fi

	distutils-r1_src_test
}

python_test() {
	eunittest tests/
}
