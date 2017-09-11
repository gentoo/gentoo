# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"
else
	dvar=e1c94e3c3c42ca9bcb336ccd7c3693bcd330c6fc
	list=9e50b8b08e0b0b75e1c651d5aa4e3cf94368a574
	rbtree=6181232360c9b517a6af3d82ebdbdce5fe36933a
	sundry=644ea3c2ce5b78d2433c111694f5d602d1aa7fa9
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
	virtual/pkgconfig
	test? ( >=sys-apps/dbus-1.10 )
"

src_prepare() {
	default
	if [[ ${PV} != 9999 ]]; then
		rmdir subprojects/{c-dvar,c-list,c-rbtree,c-sundry} || die
		ln -s "${WORKDIR}/c-dvar-${dvar}" subprojects/c-dvar || die
		ln -s "${WORKDIR}/c-list-${list}" subprojects/c-list || die
		ln -s "${WORKDIR}/c-rbtree-${rbtree}" subprojects/c-rbtree || die
		ln -s "${WORKDIR}/c-sundry-${sundry}" subprojects/c-sundry || die
	fi
}

src_configure() {
	local emesonargs=(
		-D audit=$(usex audit true false)
		-D launcher=$(usex launcher true false)
		-D selinux=$(usex selinux true false)
	)
	meson_src_configure
}
