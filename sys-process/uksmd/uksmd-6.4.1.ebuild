# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson

DESCRIPTION="Userspace KSM helper daemon"
HOMEPAGE="https://codeberg.org/pf-kernel/uksmd"
SRC_URI="https://codeberg.org/pf-kernel/uksmd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"

DEPEND="
	sys-libs/libcap-ng
	>=sys-process/procps-4:=
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~KSM"

PATCHES=(
	"${FILESDIR}"/${PN}-6.4.1-systemd-automagic.patch
)

src_configure() {
	local emesonargs=(
		$(meson_feature systemd)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	newinitd "${FILESDIR}/uksmd.init" uksmd
}
