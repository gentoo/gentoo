# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info systemd

MY_COMMIT="42f4ff8eb09011bf1a199938aa2afe23040d7faf"
MY_P="${PN}-${MY_COMMIT}"

DESCRIPTION="Userspace KSM helper daemon"
HOMEPAGE="https://gitlab.com/post-factum/uksmd"
SRC_URI="https://gitlab.com/post-factum/uksmd/-/archive/${MY_COMMIT}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-process/procps:=
	sys-kernel/pf-sources:*"
RDEPEND="${DEPEND}"

CONFIG_CHECK="KSM"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-respect-cflags-ldflags.patch" )

src_install() {
	default
	einstalldocs

	newinitd "${FILESDIR}/uksmd.init" uksmd
	systemd_dounit distro/uksmd.service
}
