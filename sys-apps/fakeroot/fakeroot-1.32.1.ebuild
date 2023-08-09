# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="de es fr nl pt sv"
inherit autotools flag-o-matic plocale

DESCRIPTION="A fake root environment by means of LD_PRELOAD and SysV IPC (or TCP) trickery"
HOMEPAGE="https://packages.qa.debian.org/f/fakeroot.html"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${P/-/_}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="acl debug nls test"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/libcap
	acl? ( sys-apps/acl )
	test? ( app-arch/sharutils )
"
BDEPEND="nls? ( app-text/po4a )"

DOCS=( AUTHORS BUGS DEBUG README doc/README.saving )

src_prepare() {
	default

	disable_locale() {
		local locale=${1}

		sed -i -e "s: ${locale}::" doc/po4a/po4a.cfg doc/Makefile.am || die
	}

	plocale_find_changes doc/po4a/po '' '.po'
	plocale_for_each_disabled_locale disable_locale

	# We could make this conditional and disable the autodependency in
	# autotools.eclass but it'd make it too easy for NLS builds to be broken
	# and us not realise.
	eautoreconf
}

src_configure() {
	export ac_cv_header_sys_acl_h=$(usex acl)
	use acl || export ac_cv_search_acl_get_fd=no # bug 759568
	use debug && append-cppflags -DLIBFAKEROOT_DEBUGGING

	# https://bugs.gentoo.org/834445
	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101270
	filter-flags -fno-semantic-interposition

	econf --disable-static
}

src_compile() {
	local enabled_locales=$(plocale_get_locales)

	if use nls && [[ -n ${enabled_locales} ]] ; then
		# Create translated man pages
		pushd doc >/dev/null || die
		po4a -v -k 0 --variable "srcdir=${S}/doc/" po4a/po4a.cfg || die
		popd >/dev/null || die
	fi

	default
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
