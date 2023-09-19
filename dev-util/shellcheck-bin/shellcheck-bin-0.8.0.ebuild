# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN/-bin/}
BASE_URI="https://github.com/koalaman/${MY_PN}/releases/download/v${PV}/${MY_PN}-v${PV}.linux"

DESCRIPTION="Shell script analysis tool (binary package)"
HOMEPAGE="https://www.shellcheck.net/"
SRC_URI="
	amd64? ( "${BASE_URI}".x86_64.tar.xz  )
	arm?   ( "${BASE_URI}".armv6hf.tar.xz )
	arm64? ( "${BASE_URI}".aarch64.tar.xz )
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64"

DEPEND="!dev-util/shellcheck"
RDEPEND="${DEPEND}"

QA_PREBUILT="/usr/bin/shellcheck"
S="${WORKDIR}/${MY_PN}-v${PV}"

src_install() {
	dobin shellcheck
	einstalldocs
}
