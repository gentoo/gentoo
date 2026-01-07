# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=xorg-server
MY_PV="$(ver_cut 1-3)-$(ver_cut 4)"
DESCRIPTION="Run a command in a virtual X server environment"
HOMEPAGE="https://packages.debian.org/sid/xvfb"
SRC_URI="mirror://debian/pool/main/${MY_PN:0:1}/${MY_PN}/${MY_PN}_${MY_PV}.diff.gz"

S="${WORKDIR}"/

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"

BDEPEND="dev-util/patchutils"
RDEPEND="x11-apps/xauth
	x11-base/xorg-server[xvfb]"

src_prepare() {
	# Not in src_unpack to silence warning "'patch' call should be moved to src_prepare"
	filterdiff \
		--include='*/xvfb-run*' \
		--exclude='*/tests/*' \
		${MY_PN}_${MY_PV}.diff | patch
	assert "filterdiff+patch failed"
	eapply_user
}

src_install() {
	doman ${PN}.1
	dobin ${PN}
}
