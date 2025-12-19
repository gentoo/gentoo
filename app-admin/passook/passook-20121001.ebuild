# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="Password generator capable of generating pronounceable and/or secure passwords"
HOMEPAGE="https://github.com/mackers/passook"
PASSOOK_COMMIT="b3905189c082b156db807842e065e3f3dd752ca8"
SRC_URI="https://github.com/mackers/passook/archive/${PASSOOK_COMMIT}.tar.gz -> ${P}.tgz"

S="${WORKDIR}/${PN}-${PASSOOK_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ppc64 x86"

RDEPEND="dev-lang/perl
	sys-apps/miscfiles"

PATCHES=( "${FILESDIR}/${PN}-20121001-prefix.patch" )

src_prepare() {
	default
	eprefixify passook
}

src_install() {
	dobin passook
	dodoc README passook.cgi
}
