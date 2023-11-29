# Copyright 1999-2023 Gentoo Authors
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
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND=">=dev-go/go-md2man-2.0.2"

src_prepare() {
	default
	eapply "${FILESDIR}/fix-warnings.patch"
}

src_compile() {
	emake docs
}

src_install() {
	emake DESTDIR="${ED}" install

	insinto /etc/containers
	doins registries.conf
}
