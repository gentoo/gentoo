# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=${PN/-bin/}

DESCRIPTION="Shell script analysis tool (binary package)"
HOMEPAGE="https://www.shellcheck.net/"
SRC_URI="
	amd64? ( https://storage.googleapis.com/${MY_PN}/${MY_PN}-v${PV}.linux.x86_64.tar.xz )
	arm? ( https://storage.googleapis.com/${MY_PN}/${MY_PN}-v${PV}.linux.armv6hf.tar.xz )
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm"

DEPEND="!dev-util/shellcheck"
RDEPEND="${DEPEND}"

QA_PREBUILT="/usr/bin/shellcheck"
S="${WORKDIR}/${MY_PN}-v${PV}"

src_install() {
	dobin shellcheck
	einstalldocs
}
