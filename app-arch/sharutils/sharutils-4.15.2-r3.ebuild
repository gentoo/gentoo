# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic strip-linguas autotools

MY_P="${P/_/-}"
DESCRIPTION="Tools to deal with shar archives"
HOMEPAGE="https://www.gnu.org/software/sharutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="nls"

DEPEND="app-arch/xz-utils
	sys-apps/texinfo
	nls? ( >=sys-devel/gettext-0.10.35 )"

PATCHES=(
	"${FILESDIR}"/${P}-glibc228.patch
	"${FILESDIR}"/${P}-CVE-2018-1000097.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-dewhich.patch
	"${FILESDIR}"/${P}-C23.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	pathfind
)

src_prepare() {
	default

	# Upstream is aware but thinks this isn't a bug/problem in sharutils itself
	# See http://lists.gnu.org/archive/html/bug-gnu-utils/2013-10/msg00011.html
	append-cflags $(test-flags-CC -Wno-error=format-security)

	# bug #943901
	append-cflags -std=gnu17

	# bug https://bugs.gentoo.org/941724
	# regenerate config after which removal
	eautoreconf
}

src_configure() {
	strip-linguas -u po
	econf $(use_enable nls)
}
