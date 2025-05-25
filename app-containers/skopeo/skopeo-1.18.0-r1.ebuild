# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module linux-info

DESCRIPTION="Work with remote container images registries"
HOMEPAGE="https://github.com/containers/skopeo"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/skopeo.git"
else
	SRC_URI="https://github.com/containers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64"
fi

# main
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
IUSE="btrfs rootless"
RESTRICT="test"

DEPEND="
	>=app-crypt/gpgme-1.5.5:=
	btrfs? ( >=sys-fs/btrfs-progs-4.0.1 )
	rootless? ( sys-apps/shadow:= )
"
RDEPEND="${DEPEND}
	app-containers/containers-common
"
BDEPEND="dev-go/go-md2man"

pkg_setup() {
	use btrfs && CONFIG_CHECK+=" ~BTRFS_FS"
	linux-info_pkg_setup
}

run_make() {
	local emakeflags=(
		BTRFS_BUILD_TAG="$(usex btrfs '' 'btrfs_noversion exclude_graphdriver_btrfs')"
		CONTAINERSCONFDIR="${EPREFIX}/etc/containers"
		LIBSUBID_BUILD_TAG="$(usex rootless 'libsubid' '')"
		PREFIX="${EPREFIX}/usr"
	)
	emake "${emakeflags[@]}" "$@"
}

src_compile() {
	run_make all completions
}

src_install() {
	# The install target in the Makefile tries to rebuild the binary and
	# installs things that are already installed by containers-common.
	dobin bin/skopeo
	einstalldocs
	doman docs/*.1
	run_make "DESTDIR=${D}" install-completions
}
