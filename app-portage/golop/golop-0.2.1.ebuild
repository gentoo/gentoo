# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
EGO_PN=github.com/klausman/golop
inherit go-module

DESCRIPTION="Pure Go re-implementation of genlop"
HOMEPAGE="https://github.com/klausman/golop"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/klausman/golop"
else
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	EGIT_COMMIT=v${PV}
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND=">=dev-lang/go-1.15.0"

src_compile() {
	ego build .
}

src_install() {
	dobin ${PN}

	einstalldocs
}
