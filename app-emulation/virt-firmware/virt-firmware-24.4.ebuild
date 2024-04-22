# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 optfeature pypi systemd

DESCRIPTION="Tools for ovmf/armvirt firmware volumes"
HOMEPAGE="
	https://gitlab.com/kraxel/virt-firmware
	https://pypi.org/project/virt-firmware/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# Currently requires files in /boot and read/write to efivars
RESTRICT="test"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pefile[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}

python_install_all() {
	distutils-r1_python_install_all

	doman man/*.1

	doinitd "${FILESDIR}/kernel-bootcfg-boot-successful"
	systemd_dounit systemd/kernel-bootcfg-boot-successful.service

	# Use our own provided by sys-kernel/installkernel[efistub,systemd]
	#exeinto /usr/lib/kernel/install.d
	#doexe systemd/99-uki-uefi-setup.install
}

pkg_postinst() {
	optfeature "automatically updating UEFI configuration on each kernel installation or removal" \
		"sys-kernel/installkernel[systemd,efistub]"
}
