# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Default config and docs related to Containers' storage"
HOMEPAGE="https://github.com/containers/storage"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/storage.git"
else
	SRC_URI="https://github.com/containers/storage/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P#containers-}"
	KEYWORDS="amd64 arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND=">=dev-go/go-md2man-2.0.2"

src_prepare() {
	default
	eapply "${FILESDIR}"/system-md2man-path.patch
}

src_compile() {
	emake -C docs containers-storage.conf.5
}

src_install() {
	emake DESTDIR="${ED}" -C docs install

	insinto /etc/containers
	doins storage.conf
}
