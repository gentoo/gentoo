# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit python-r1 meson

DESCRIPTION="C Library for NVM Express on Linux"
HOMEPAGE="https://github.com/linux-nvme/libnvme"
SRC_URI="https://github.com/linux-nvme/libnvme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"
IUSE="dbus +json keyutils python ssl +uuid"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	json? ( dev-libs/json-c:= )
	keyutils? ( sys-apps/keyutils:= )
	dbus? ( sys-apps/dbus:= )
	python? ( ${PYTHON_DEPS} )
	ssl? ( >=dev-libs/openssl-1.1:= )
	uuid? ( sys-apps/util-linux:= )
"
RDEPEND="${DEPEND}"

BDEPEND="
	dev-lang/swig
"

src_configure() {
	local emesonargs=(
		-Dpython=false
		$(meson_feature json json-c)
		$(meson_feature dbus libdbus)
		$(meson_feature ssl openssl)
		$(meson_feature python)
	)
	meson_src_configure
}

python_compile() {
	local emesonargs=(
		-Dpython=enabled
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
