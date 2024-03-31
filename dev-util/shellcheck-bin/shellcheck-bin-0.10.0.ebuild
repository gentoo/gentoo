# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SC_P=${PN%-bin}-v${PV}
SC_URI="https://github.com/koalaman/shellcheck/releases/download/v${PV}/${SC_P}.linux"

DESCRIPTION="Shell script analysis tool (binary package)"
HOMEPAGE="https://www.shellcheck.net/"
SRC_URI="
	amd64? ( ${SC_URI}.x86_64.tar.xz  )
	arm64? ( ${SC_URI}.aarch64.tar.xz )
	arm? ( ${SC_URI}.armv6hf.tar.xz )
"
S=${WORKDIR}/${SC_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="-* amd64 ~arm ~arm64"

RDEPEND="!dev-util/shellcheck"

QA_PREBUILT="usr/bin/shellcheck"

src_install() {
	dobin shellcheck
	einstalldocs
}
