# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"
else
	SRC_URI="https://github.com/bus1/${PN}/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
fi

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker/wiki"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="apparmor audit doc +launcher selinux"

DEPEND="
	apparmor? (
		>=sys-libs/libapparmor-3.0
	)
	audit? (
		>=sys-process/audit-3.0
		>=sys-libs/libcap-ng-0.6
	)
	launcher? (
		>=dev-libs/expat-2.2
		>=sys-apps/systemd-230:0=
	)
	selinux? ( >=sys-libs/libselinux-3.2 )
"
RDEPEND="${DEPEND}
	launcher? ( sys-apps/dbus )"
BDEPEND="
	doc? ( dev-python/docutils )
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/dbus-broker-32-apparmor-libaudit.patch"
)

if [[ ${PV} == 9999 ]]; then
src_unpack() {
	git-r3_src_unpack
	cd "${P}" || die
	meson subprojects download || die
}
fi

src_configure() {
	local emesonargs=(
		$(meson_use apparmor)
		$(meson_use audit)
		$(meson_use doc docs)
		$(meson_use launcher)
		$(meson_use selinux)
	)
	meson_src_configure
}
