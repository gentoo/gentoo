# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit flag-o-matic

DESCRIPTION="Tools to make diffs and compare files"
HOMEPAGE="https://www.gnu.org/software/diffutils/"
SRC_URI="mirror://gnu/diffutils/${P}.tar.xz
	mirror://gnu-alpha/diffutils/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static"

DEPEND="app-arch/xz-utils
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_configure() {
	use static && append-ldflags -static

	# Disable automagic dependency over libsigsegv; see bug #312351.
	export ac_cv_libsigsegv=no

	econf \
		--with-packager="Gentoo" \
		--with-packager-version="${PVR}" \
		--with-packager-bug-reports="https://bugs.gentoo.org/" \
		$(use_enable nls)
}

src_test() {
	# explicitly allow parallel testing
	emake check
}
