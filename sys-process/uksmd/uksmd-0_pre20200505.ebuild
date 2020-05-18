# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd

MY_COMMIT="b6af35cb9a772f643fd1bd703f4d1f6c6c6d3b79"
MY_P="${PN}-${MY_COMMIT}"

DESCRIPTION="Userspace KSM helper daemon"
HOMEPAGE="https://gitlab.com/post-factum/uksmd"
SRC_URI="https://gitlab.com/post-factum/uksmd/-/archive/${MY_COMMIT}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/libcap-ng
	sys-process/procps:="
RDEPEND="${DEPEND}"

CONFIG_CHECK="~KSM"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/uksmd-0_pre20200504-respect-cflags-ldflags.patch" )

src_install() {
	default
	einstalldocs

	newinitd "${FILESDIR}/uksmd.init" uksmd
	systemd_dounit distro/uksmd.service
}
