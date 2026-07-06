# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module linux-info

DESCRIPTION="Work with remote container images registries"
HOMEPAGE="https://github.com/podman-container-tools/skopeo"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/podman-container-tools/skopeo.git"
else
	SRC_URI="https://github.com/podman-container-tools/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

# main
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
IUSE="btrfs rootless selinux"
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.5.5:=
	dev-db/sqlite:3
	btrfs? ( >=sys-fs/btrfs-progs-4.0.1 )
	rootless? ( sys-apps/shadow:= )
	selinux? ( sec-policy/selinux-podman sys-libs/libselinux:= )
"
RDEPEND="${DEPEND}
	>=app-containers/container-libs-0.68.0
"
BDEPEND="
	dev-go/go-md2man
	>=dev-lang/go-1.25.6
"
PATCHES=( "${FILESDIR}"/handle-conflicts-with-c-libs-pr2173.patch )

pkg_setup() {
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	linux-info_pkg_setup
}

run_make() {
	local emakeflags=(
		BTRFS_BUILD_TAG="$(usex btrfs '' 'exclude_graphdriver_btrfs')"
		LIBSUBID_BUILD_TAG="$(usex rootless 'libsubid' '')"
		SQLITE_BUILD_TAG="libsqlite3"
		PREFIX="${EPREFIX}/usr"
	)
	emake "${emakeflags[@]}" "$@"
}

src_compile() {
	run_make
}

src_install() {
	run_make "DESTDIR=${D}" install
}
