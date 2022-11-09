# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson systemd

MY_COMMIT="f10f38e3adcaf6175e6c4c1846cad72ae9ab2cf2"

DESCRIPTION="Userspace KSM helper daemon"
HOMEPAGE="https://codeberg.org/pf-kernel/uksmd"
SRC_URI="https://codeberg.org/pf-kernel/uksmd/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/libcap-ng
	sys-process/procps:="
RDEPEND="${DEPEND}"

CONFIG_CHECK="~KSM"

S="${WORKDIR}/uksmd"

PATCHES=( "${FILESDIR}"/uksmd-0-remove-systemd-dep.patch )

src_install() {
	meson_src_install

	newinitd "${FILESDIR}/uksmd.init" uksmd
	systemd_dounit uksmd.service
}
