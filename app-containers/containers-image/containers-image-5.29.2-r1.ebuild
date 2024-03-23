# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Default config and docs related to Containers' images"
HOMEPAGE="https://github.com/containers/image"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/image.git"
else
	SRC_URI="https://github.com/containers/image/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P#containers-}"
	KEYWORDS="amd64 arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"

# https://github.com/gentoo/gentoo/pull/35012#discussion_r1473740969
RESTRICT='test'
BDEPEND=">=dev-go/go-md2man-2.0.3"
PATCHES=(
	"${FILESDIR}"/moving-policy-json-default-yaml.patch
	"${FILESDIR}"/prevent-downloading-mods-5.29.2.patch
)

src_compile() {
	emake docs
}

src_install() {
	emake DESTDIR="${ED}" install

	insinto /etc/containers
	doins registries.conf
}
