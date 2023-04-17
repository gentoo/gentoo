# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

GIT_COMMIT="9fc4e3e4e3f1231cabfdc2e1438155f9390bc517"

DESCRIPTION="Command-line program for getting and setting the contents of the X selection"
HOMEPAGE="https://vergenet.net/~conrad/software/xsel"
SRC_URI="https://github.com/kfish/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Werror.patch
	"${FILESDIR}"/${P}-modernize.patch
)

src_prepare() {
	default
	eautoreconf
}
