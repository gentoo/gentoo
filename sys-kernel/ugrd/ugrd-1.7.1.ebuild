# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
inherit distutils-r1 optfeature shell-completion

DESCRIPTION="Python based initramfs generator with TOML defintions"
HOMEPAGE="https://github.com/desultory/ugrd"
SRC_URI="https://github.com/desultory/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	app-misc/pax-utils
	>=dev-python/zenlib-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/pycpio-1.1.2[${PYTHON_USEDEP}]
	sys-apps/pciutils
"

src_install() {
	# Call the distutils-r1_src_install function to install the package
	distutils-r1_src_install
	# Create the ugrd config directory
	keepdir /etc/ugrd
	# Install the example config into /etc/ugrd/config.toml
	# Do not overwrite an existing config
	insinto /etc/ugrd
	newins examples/example.toml config.toml
	# Create the kernel preinst.d directory if it doesn't exist
	# Install the kernel preinst.d hook
	# TODO: This should be part of installkernel
	keepdir /usr/lib/kernel/preinst.d
	exeinto /usr/lib/kernel/preinst.d
	doexe hooks/installkernel/51-ugrd.install
	exeinto /usr/lib/kernel/install.d
	doexe hooks/kernel-install/51-ugrd.install
	# Install bash and zsh completion scripts
	dobashcomp completion/ugrd
	dozshcomp completion/_ugrd
}

pkg_postinst() {
	optfeature "ugrd.crypto.cryptsetup support" sys-fs/cryptsetup
	optfeature "ugrd.fs.btrfs support" sys-fs/btrfs-progs
	optfeature "ugrd.crypto.gpg support" app-crypt/gnupg
}
