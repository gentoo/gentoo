# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utility for changing the Bluetooth device address"
HOMEPAGE="https://github.com/thxomas/bdaddr"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/thxomas/bdaddr"
else
	MY_COMMIT=53dae3f6a33bca202ddae0e7b14beeaf2d7d653b
	SRC_URI="
		https://github.com/thxomas/bdaddr/archive/${MY_COMMIT}.tar.gz
			-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
fi

# https://github.com/thxomas/bdaddr/pull/6
SRC_URI+="
	https://github.com/Flowdalic/bdaddr/commit/85eeb2a13ab664432ce357cdb0641163fc541a99.patch
		-> ${PN}-0_p20210511-idiomatic-makefile-r1.patch
"

LICENSE="GPL-2+"
SLOT="0"

COMMON_DEPEND="
	net-wireless/bluez:=
"
RDEPEND="
	${COMMON_DEPEND}
	sys-apps/hwdata
"
DEPEND="
	${COMMON_DEPEND}
"
BDEPEND="dev-go/go-md2man"

PATCHES=(
	"${DISTDIR}"/${PN}-0_p20210511-idiomatic-makefile-r1.patch
)

src_compile() {
	emake

	go-md2man -in README.md -out ${PN}.1 || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dosym ../hwdata/oui.txt usr/share/misc/oui.txt
}
