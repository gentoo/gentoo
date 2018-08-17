# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN=github.com/projectatomic/skopeo
COMMIT=b0b750d
inherit golang-vcs-snapshot

DESCRIPTION="Command line utility foroperations on container images and image repositories"
HOMEPAGE="https://github.com/projectatomic/skopeo"
SRC_URI="https://github.com/projectatomic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=app-crypt/gpgme-1.5.5:=
	>=dev-libs/libassuan-2.4.3
	>=sys-fs/btrfs-progs-4.0.1
	>=sys-fs/lvm2-2.02.145"
DEPEND="${COMMON_DEPEND}
	dev-go/go-md2man"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${P}/src/${EGO_PN}"

RESTRICT="test"

src_compile() {
	local BUILDTAGS="containers_image_ostree_stub"
	set -- env GOPATH="${WORKDIR}/${P}" \
		go build -ldflags "-X main.gitCommit=${COMMIT}" \
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
	insinto /etc/containers
	newins default-policy.json policy.json
	insinto /etc/containers/registries.d
	doins default.yaml
	keepdir /var/lib/atomic/sigstore
	einstalldocs
}
