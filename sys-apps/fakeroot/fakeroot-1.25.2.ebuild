# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="A fake root environment by means of LD_PRELOAD and SysV IPC (or TCP) trickery"
HOMEPAGE="https://packages.qa.debian.org/f/fakeroot.html"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${P/-/_}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="acl debug static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/libcap
	acl? ( sys-apps/acl )
	test? ( app-arch/sharutils )"
BDEPEND="app-text/po4a"

DOCS="AUTHORS BUGS DEBUG README doc/README.saving"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	# Create tranlated man pages
	pushd doc &>/dev/null || die
	po4a -v -k 0 --variable "srcdir=${S}/doc/" po4a/po4a.cfg || die
	popd &>/dev/null || die

	default
}

src_configure() {
	export ac_cv_header_sys_acl_h=$(usex acl)

	use debug && append-cppflags "-DLIBFAKEROOT_DEBUGGING"
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -o -name '*.a' -delete || die
}
