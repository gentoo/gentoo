# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-utils-r1 python-r1 meson

DESCRIPTION="C Library for NVM Express on Linux"
HOMEPAGE="https://github.com/linux-nvme/libnvme"
LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+json python ssl +uuid"

SRC_URI="https://github.com/linux-nvme/libnvme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

DEPEND="
	json? ( dev-libs/json-c:= )
	python? ( ${PYTHON_DEPS} )
	ssl? ( >=dev-libs/openssl-1.1:= )
	uuid? ( sys-apps/util-linux:= )
"
RDEPEND="${DEPEND}"

BDEPEND="
	dev-lang/swig
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

src_configure() {
	local emesonargs=(
		-Dpython=false
	)
	meson_src_configure
}

python_compile() {
	local emesonargs=(
		-Dpython=true
	)
	meson_src_configure --reconfigure
	meson_src_compile
}

src_compile() {
	meson_src_compile

	if use python; then
		python_copy_sources
		python_foreach_impl python_compile
	fi
}

python_install() {
	meson_src_install
	use python && python_optimize
}

src_install() {
	use python && python_foreach_impl python_install

	meson_src_install
}
