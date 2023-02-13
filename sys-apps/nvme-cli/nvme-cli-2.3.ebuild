# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd udev

DESCRIPTION="NVM-Express user space tooling for Linux"
HOMEPAGE="https://github.com/linux-nvme/nvme-cli"
SRC_URI="https://github.com/linux-nvme/nvme-cli/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="hugepages"

RDEPEND="
	>=sys-libs/libnvme-1.3:=
	hugepages? ( sys-libs/libhugetlbfs:= )
	dev-libs/json-c:=
	sys-libs/zlib:=
"

DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/nvme-cli-2.2-docdir.patch"
	"${FILESDIR}/nvme-cli-2.3-no-hugetlbfs-automatic-dep.patch"
)

src_configure() {
	local unitdir="$(systemd_get_systemunitdir)"
	local emesonargs=(
		-Ddocs=all
		-Dhtmldir="${EPREFIX}/usr/share/doc/${P}/html"
		-Dsystemddir="${unitdir%/system}"
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)"
		$(meson_use hugepages)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
