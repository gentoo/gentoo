# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"
else
	dvar=9fcd89593f8b7fb5c9f1c32f0b82f518eda4be46
	list=dda36d30c7d655b4d61358519168fa7ce0e9dae9
	rbtree=bf627e0c32241915108f66ad9738444e4d045b45
	sundry=50c8ccf01b39b3f11e59c69d1cafea5bef5a9769
	utf8=b245df543717ee19ad398f8139447e3807c11c96
	SRC_URI="https://github.com/bus1/dbus-broker/archive/v${PV}/${P}.tar.gz
		https://github.com/c-util/c-dvar/archive/${dvar}/c-dvar-${dvar}.tar.gz
		https://github.com/c-util/c-list/archive/${list}/c-list-${list}.tar.gz
		https://github.com/c-util/c-rbtree/archive/${rbtree}/c-rbtree-${rbtree}.tar.gz
		https://github.com/c-util/c-sundry/archive/${sundry}/c-sundry-${sundry}.tar.gz
		https://github.com/c-util/c-utf8/archive/${utf8}/c-utf8-${utf8}.tar.gz
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker/wiki"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="audit doc +launcher selinux"

RDEPEND="
	audit? (
		>=sys-process/audit-2.7
		>=sys-libs/libcap-ng-0.6
	)
	doc? ( dev-python/docutils )
	launcher? (
		>=sys-apps/dbus-1.10
		>=dev-libs/expat-2.2
		>=dev-libs/glib-2.50:2
		>=sys-apps/systemd-230
	)
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}
	dev-python/docutils
	virtual/pkgconfig
"

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		rmdir subprojects/{c-dvar,c-list,c-rbtree,c-sundry,c-utf8} || die
		mv "${WORKDIR}/c-dvar-${dvar}" subprojects/c-dvar || die
		mv "${WORKDIR}/c-list-${list}" subprojects/c-list || die
		mv "${WORKDIR}/c-rbtree-${rbtree}" subprojects/c-rbtree || die
		mv "${WORKDIR}/c-sundry-${sundry}" subprojects/c-sundry || die
		mv "${WORKDIR}/c-utf8-${utf8}" subprojects/c-utf8 || die
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
