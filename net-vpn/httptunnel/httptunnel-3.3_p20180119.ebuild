# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

COMMIT="f440dcb3c341d22428898952c343ad9fa6e9e7f5"
DESCRIPTION="httptunnel can create IP tunnels through firewalls/proxies using HTTP"
HOMEPAGE="https://github.com/larsbrinkhoff/httptunnel"
SRC_URI="https://github.com/larsbrinkhoff/httptunnel/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${PN}-3.3_p20180119-respect-AR.patch"
)

src_prepare() {
	default

	tc-export AR RANLIB
	eautoreconf
}
