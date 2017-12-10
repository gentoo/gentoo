# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"
else
	dvar=7706828ecda2d8c508d6fc233dc9d198bab482ad
	list=72c59181d677a3f50b201d51f190b1bff02d4279
	rbtree=825f626a16257c5f0b0c523c11ce1bca16851180
	sundry=50c8ccf01b39b3f11e59c69d1cafea5bef5a9769
	SRC_URI="https://github.com/bus1/dbus-broker/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/c-util/c-dvar/archive/${dvar}.tar.gz -> c-dvar-${dvar}.tar.gz
		https://github.com/c-util/c-list/archive/${list}.tar.gz -> c-list-${list}.tar.gz
		https://github.com/c-util/c-rbtree/archive/${rbtree}.tar.gz -> c-rbtree-${rbtree}.tar.gz
		https://github.com/c-util/c-sundry/archive/${sundry}.tar.gz -> c-sundry-${sundry}.tar.gz
	"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker/wiki"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="audit +launcher selinux test"
RESTRICT="!test? ( test )"

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
	test? ( >=sys-apps/dbus-1.10 )
"

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		rmdir subprojects/{c-dvar,c-list,c-rbtree,c-sundry} || die
		mv "${WORKDIR}/c-dvar-${dvar}" subprojects/c-dvar || die
		mv "${WORKDIR}/c-list-${list}" subprojects/c-list || die
		mv "${WORKDIR}/c-rbtree-${rbtree}" subprojects/c-rbtree || die
		mv "${WORKDIR}/c-sundry-${sundry}" subprojects/c-sundry || die
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
