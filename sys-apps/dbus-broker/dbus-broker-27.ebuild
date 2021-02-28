# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"
else
	KEYWORDS="~amd64 ~ppc64"
	SRC_URI="https://github.com/bus1/dbus-broker/archive/v${PV}/${P}.tar.gz"
	declare -Ag SUBPROJECTS=(
		[c-dvar]=70f0f21e86a34577e674e202d5d09ef167102f02
		[c-ini]=867f06a12a702c6869924575503877caa0adde75
		[c-list]=96455db9f04a6c9101a00957161551aea700b6aa
		[c-rbtree]=a3b1f80548d1c736208c55e9251c49ada649dd62
		[c-shquote]=95e4713a0de475688a5727a5d776dccbc69d3d28
		[c-stdaux]=346623b40eb8137cae7568a69ee42253ff098ff7
		[c-utf8]=af5bf7f330078d285e5f58584abd6de01c4cfd7d
	)
	for sp in "${!SUBPROJECTS[@]}"; do
		commit=${SUBPROJECTS[${sp}]}
		SRC_URI+=" https://github.com/c-util/${sp}/archive/${commit}/${sp}-${commit}.tar.gz"
	done
	unset sp commit
fi

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker/wiki"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="audit doc +launcher selinux"

DEPEND="
	audit? (
		>=sys-process/audit-2.7
		>=sys-libs/libcap-ng-0.6
	)
	launcher? (
		>=dev-libs/expat-2.2
		>=sys-apps/systemd-230:0=
	)
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${DEPEND}
	launcher? ( sys-apps/dbus )"
BDEPEND="
	doc? ( dev-python/docutils )
	virtual/pkgconfig
"

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		local sp commit
		for sp in "${!SUBPROJECTS[@]}"; do
			commit=${SUBPROJECTS[${sp}]}
			rmdir "subprojects/${sp}" || die
			mv "${WORKDIR}/${sp}-${commit}" "subprojects/${sp}" || die
		done
	fi
	default
}

src_configure() {
	local emesonargs=(
		-Daudit=$(usex audit true false)
		-Ddocs=$(usex doc true false)
		-Dlauncher=$(usex launcher true false)
		-Dselinux=$(usex selinux true false)
	)
	meson_src_configure
}
