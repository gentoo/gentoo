# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
COMMIT=be6146b
inherit go-module bash-completion-r1

DESCRIPTION="Command line utility foroperations on container images and image repositories"
HOMEPAGE="https://github.com/containers/skopeo"
CONTAINERS_STORAGE_PATCH="containers-storage-1.14.0-vfs-user-xattrs.patch"
SRC_URI="https://github.com/containers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/containers/storage/pull/466.patch -> ${CONTAINERS_STORAGE_PATCH}"

LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=app-crypt/gpgme-1.5.5:=
	>=dev-libs/libassuan-2.4.3:=
	dev-libs/libgpg-error:=
	>=sys-fs/btrfs-progs-4.0.1
	>=sys-fs/lvm2-2.02.145:="
DEPEND="${COMMON_DEPEND}
	dev-go/go-md2man"
RDEPEND="${COMMON_DEPEND}"

RESTRICT="test"

src_prepare() {
	default
	sed -e 's| \([ab]\)/| \1/vendor/github.com/containers/storage/|' < \
		"${DISTDIR}/${CONTAINERS_STORAGE_PATCH}" > \
		"${WORKDIR}/${CONTAINERS_STORAGE_PATCH}" || die
	eapply "${WORKDIR}/${CONTAINERS_STORAGE_PATCH}"
}

src_compile() {
	local BUILDTAGS="containers_image_ostree_stub"
	set -- env -u GOCACHE -u XDG_CACHE_HOME \
		go build -mod=vendor -ldflags "-X main.gitCommit=${COMMIT}" \
		-gcflags "${GOGCFLAGS}" -tags "${BUILDTAGS}" \
		-o skopeo ./cmd/skopeo
	echo "$@"
	"$@" || die
	cd docs || die
	for f in *.1.md; do
		go-md2man -in ${f} -out ${f%%.md} || die
	done
}

src_install() {
	dobin skopeo
	doman docs/*.1
	dobashcomp completions/bash/skopeo
	insinto /etc/containers
	newins default-policy.json policy.json
	insinto /etc/containers/registries.d
	doins default.yaml
	keepdir /var/lib/atomic/sigstore
	einstalldocs
}
