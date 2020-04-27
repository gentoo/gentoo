# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd

MY_COMMIT="9b6a6e55e07c524ba0a36eb25c869b47655010ee"
MY_P="${PN}-${MY_COMMIT}"

DESCRIPTION="Userspace KSM helper daemon"
HOMEPAGE="https://gitlab.com/post-factum/uksmd"
SRC_URI="https://gitlab.com/post-factum/uksmd/-/archive/${MY_COMMIT}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-process/procps:="
RDEPEND="${DEPEND}"

CONFIG_CHECK="~KSM"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/uksmd-0_pre20190726-respect-cflags-ldflags.patch" )

src_install() {
	default
	einstalldocs

	newinitd "${FILESDIR}/uksmd.init" uksmd
	systemd_dounit distro/uksmd.service
}
