# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils flag-o-matic

MY_P="${P/_/-}"
DESCRIPTION="Tools to deal with shar archives"
HOMEPAGE="https://www.gnu.org/software/sharutils/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

DEPEND="app-arch/xz-utils
	sys-apps/texinfo
	nls? ( >=sys-devel/gettext-0.10.35 )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	epatch "${FILESDIR}/sharutils-4.15.2-glibc228.patch"
	epatch "${FILESDIR}/sharutils-4.15.2-CVE-2018-1000097.patch"

	# Upstream is aware but thinks this isn't a bug/problem in sharutils itself
	# See http://lists.gnu.org/archive/html/bug-gnu-utils/2013-10/msg00011.html
	append-cflags $(test-flags-CC -Wno-error=format-security)
}

src_configure() {
	strip-linguas -u po
	econf $(use_enable nls)
}
