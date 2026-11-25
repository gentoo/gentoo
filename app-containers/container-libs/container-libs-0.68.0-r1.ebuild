# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit readme.gentoo-r1

DESCRIPTION="Several utilities from the containers project"
HOMEPAGE="https://github.com/podman-container-tools/container-libs"
SRC_URI="https://github.com/podman-container-tools/container-libs/archive/common/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-common-v${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv"
IUSE="+extra"
RESTRICT="test"

RDEPEND="
	app-containers/containers-shortnames
	>=sys-fs/fuse-overlayfs-1.16
	extra? (
		>=app-containers/crun-1.25.1
		>=app-containers/netavark-2.0.0
		>=net-misc/passt-2026.05.26
	)
	!app-containers/containers-image
	!app-containers/containers-common
	!app-containers/containers-storage
	!<app-containers/buildah-1.44.0
	!<app-containers/podman-6.0.0
	!<app-containers/skopeo-1.23
"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-go/go-md2man-2.0.7"
PATCHES=(
	"${FILESDIR}"/c-libs-0.68.0-remove-go-cc.patch
	"${FILESDIR}"/c-libs-pr989-correct-CONTAINERSCONFDIR.patch
)

DOC_CONTENTS="
For rootless operations, one needs to configure subuid(5) and subgid(5).
See /etc/sub{uid,gid} to check whether rootless user is already configured.
If not, quickly configure it with:\n
usermod --add-subuids 1065536-1131071 <rootless user>\n
usermod --add-subgids 1065536-1131071 <rootless user>
"

src_compile() {
	emake -C common PREFIX="${EPREFIX}/usr" docs
	emake -C image docs
	emake -C storage docs
	touch {images,layers}.lock || die
}

src_install() {
	emake -C common DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	emake -C image DESTDIR="${ED}" install
	emake -C storage DESTDIR="${ED}" install
	readme.gentoo_create_doc

	insinto /usr/share/containers
	doins common/pkg/{seccomp/seccomp.json,subscriptions/mounts.conf} storage/storage.conf image/registries.conf

	keepdir /etc/containers/{certs.d,oci/hooks.d,networks,systemd,registries.conf.d,registries.d} \
			/var/lib/containers/sigstore /usr/share/containers/systemd

	diropts -m0700
	dodir /usr/lib/containers/storage/overlay-{images,layers}
	local i
	for i in images layers; do
		insinto /usr/lib/containers/storage/overlay-"${i}"
		doins "${i}".lock
	done
	insinto /usr/share/containers/registries.conf.d
	newins "${FILESDIR}/c-libs-0.68.0-registries.conf" 00-gentoo.conf
}

pkg_postinst() {
	readme.gentoo_print_elog
}
