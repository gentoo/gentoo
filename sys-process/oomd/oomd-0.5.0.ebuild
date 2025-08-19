# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson

DESCRIPTION="Userspace Out-Of-Memory (OOM) killer"
HOMEPAGE="https://github.com/facebookincubator/oomd"
SRC_URI="https://github.com/facebookincubator/oomd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2"
SLOT="0"
IUSE="systemd test"
RESTRICT="!test? ( test )"
DEPEND="dev-libs/jsoncpp:=
	dev-util/meson:=
	systemd? ( sys-apps/systemd:= )
	"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig
	test? ( dev-cpp/gtest:= )
	"

CONFIG_CHECK="CGROUPS PSI"

src_configure() {
	if use systemd ; then
		elog "SYSTEMD WHAT"
		local emesonargs=(
				$(meson_feature systemd libsystemd)
		)
	fi
	meson_src_configure
}

src_test() {
	meson_src_test
}

pkg_postinst() {
	elog "See the following wiki for configuring oomd:"
	elog "https://github.com/facebookincubator/oomd/blob/master/docs/configuration.md"
	elog
	elog "The host must be running cgroup2 alone."
	elog
	elog "See the wiki for configuration related to cgroups:"
	elog "https://wiki.gentoo.org/wiki/OpenRC/CGroups"
}
