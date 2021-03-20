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
		[c-dvar]=eeb91604574f7c5b12b270f8355f7e6cf1720f4c
		[c-ini]=204410a08d3a6c8221f6f0baf0355ce5af0232ed
		[c-list]=f1eadf27377ef2f74b3cfd16185f54a219df2aae
		[c-rbtree]=8aa7bd1828eedb19960f9eef98d15543ec9f34eb
		[c-shquote]=83ccc2893385fcca1424b188f0f6c45a62f2b38d
		[c-stdaux]=c5f166d02ff68af5cdcbad1bdcea2cb134e34ce4
		[c-utf8]=8a8f07d623492d4b45532527f945b118a2b4299b
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
