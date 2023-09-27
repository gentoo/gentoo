# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Configures default shortnames (aliases) for Containers"
HOMEPAGE="https://github.com/containers/shortnames"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/containers/shortnames.git"
else
	SRC_URI="https://github.com/containers/shortnames/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P#containers-}"
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"

src_configure() {
	return
}

src_compile() {
	return
}

src_test() {
	return
}

src_install() {
	insinto /etc/containers/registries.conf.d
	newins shortnames.conf 000-shortnames.conf
}
