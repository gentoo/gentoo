# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"
else
	dvar=f0a525477142f64c45b0be9393cc3b5dc3a6d6f9
	list=05bada3508c21027dbbbf1319f27ed65c7c03bc0
	rbtree=ba0527e9157316cdb60522f23fb884ea196b1346
	sundry=50c8ccf01b39b3f11e59c69d1cafea5bef5a9769
	utf8=cc67174f455c9196ebffc37b4d4f249da3dbc66f
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
IUSE="audit +launcher selinux"

RDEPEND="
	audit? ( sys-process/audit )
	launcher? (
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
		-D audit=$(usex audit true false)
		-D launcher=$(usex launcher true false)
		-D selinux=$(usex selinux true false)
	)
	meson_src_configure
}
