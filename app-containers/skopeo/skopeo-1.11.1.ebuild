# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
COMMIT=fb1ade6d9e9b501e35b09538c9533fac5dd604b6
inherit go-module

DESCRIPTION="Command line utility foroperations on container images and image repositories"
HOMEPAGE="https://github.com/containers/skopeo"
SRC_URI="https://github.com/containers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="btrfs"

COMMON_DEPEND=">=app-crypt/gpgme-1.5.5:=
	>=dev-libs/libassuan-2.4.3:=
	dev-libs/libgpg-error:=
	btrfs? ( >=sys-fs/btrfs-progs-4.0.1 )
	>=sys-fs/lvm2-2.02.145:="
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
	BDEPEND="dev-go/go-md2man"

RESTRICT="test"

src_compile() {
	local BUILDTAGS
	BUILDTAGS="containers_image_ostree_stub $(usex btrfs "" exclude_graphdriver_btrfs)"
	emake PREFIX=/usr BUILDTAGS="${BUILDTAGS}" GIT_COMMIT="${COMMIT}" \
		all completions
}

src_install() {
	emake PREFIX=/usr DESTDIR="${ED}" install
	keepdir /var/lib/containers/sigstore
}
