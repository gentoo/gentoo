# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

# for virtme-ng-init
CRATES="
	base64@0.22.1
	bitflags@2.8.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	libc@0.2.169
	log@0.4.21
	nix@0.29.0
	uzers@0.12.1
"

inherit bash-completion-r1 cargo distutils-r1

MY_COMMIT=aa57790b71a05490c773c873bccd66d96dbeea1c

DESCRIPTION="Quickly build and run kernels inside a virtualized snapshot of your live system"
HOMEPAGE="https://github.com/arighi/virtme-ng"

SRC_URI="
	https://github.com/arighi/virtme-ng/archive/${MY_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}/${PN}-${MY_COMMIT}"
LICENSE="GPL-2"
# Dependent crate licenses for virtme-ng-init
LICENSE+=" MIT"
SLOT="0"

KEYWORDS="amd64"

DEPEND="
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
	app-emulation/qemu
	app-emulation/virtiofsd
	net-misc/openssh
	net-misc/socat
	sys-apps/busybox[static]
"
BDEPEND="dev-python/argparse-manpage[${PYTHON_USEDEP}]"

src_prepare() {
	default

	sed -i /data_files=data_files/d setup.py || die
}

src_configure() {
	distutils-r1_src_configure

	cd virtme_ng_init || die
	cargo_src_configure
}

src_compile() {
	distutils-r1_src_compile

	cd virtme_ng_init || die
	cargo_src_compile
}

src_test() {
	distutils-r1_src_test

	cd virtme_ng_init || die
	cargo_src_test
}

src_install() {
	distutils-r1_src_install
	insinto etc
	doins cfg/${PN}.conf
	dobashcomp virtme-ng-prompt vng-prompt

	cd virtme_ng_init || die
	cargo_src_install
}
