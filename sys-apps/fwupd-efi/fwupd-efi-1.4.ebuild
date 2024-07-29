# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit meson python-any-r1 secureboot toolchain-funcs

DESCRIPTION="EFI executable for fwupd"
HOMEPAGE="https://fwupd.org"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fwupd/fwupd-efi.git"
else
	SRC_URI="https://github.com/fwupd/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

BDEPEND="$(python_gen_any_dep '
		dev-python/pefile[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig"

DEPEND="sys-boot/gnu-efi"

RDEPEND="!<sys-apps/fwupd-1.6.0"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-efi_ld_override.patch	# Bug #892339
)

python_check_deps() {
	python_has_version "dev-python/pefile[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
	secureboot_pkg_setup
}

src_prepare() {
	default

	python_fix_shebang "${S}/efi"
}

src_configure() {
	local emesonargs=(
		-Defi-ld="$(tc-getLD)"
		-Defi-libdir="${EPREFIX}"/usr/$(get_libdir)
		-Defi_sbat_distro_id="gentoo"
		-Defi_sbat_distro_summary="Gentoo GNU/Linux"
		-Defi_sbat_distro_pkgname="${PN}"
		-Defi_sbat_distro_version="${PVR}"
		-Defi_sbat_distro_url="https://packages.gentoo.org/packages/${CATEGORY}/${PN}"
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	secureboot_auto_sign
}
