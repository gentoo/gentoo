# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Note: Keep version bumps in sync with sys-devel/gettext.

EAPI=7

MY_P="gettext-${PV}"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/gettext.asc
inherit multilib-minimal libtool usr-ldscript verify-sig

DESCRIPTION="the GNU international library (split out of gettext)"
HOMEPAGE="https://www.gnu.org/software/gettext/"
SRC_URI="mirror://gnu/gettext/${MY_P}.tar.gz"
SRC_URI+=" verify-sig? ( mirror://gnu/gettext/${MY_P}.tar.gz.sig )"
S="${WORKDIR}/${MY_P}/gettext-runtime"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="static-libs +threads"

DEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]"
# Block C libraries known to provide libintl.
RDEPEND="${DEPEND}
	!sys-libs/glibc
	!sys-libs/musl
	!<sys-devel/gettext-0.19.6-r1"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gettext )"

src_prepare() {
	default

	# The libtool files are stored higher up, so make sure we run in the
	# whole tree and not just the subdir we build.
	elibtoolize "${WORKDIR}"
}

multilib_src_configure() {
	local myconf=(
		# Emacs support is now in a separate package.
		--without-emacs
		--without-lispdir
		# Normally this controls nls behavior in general, but the libintl
		# subdir is skipped unless this is explicitly set.  ugh.
		--enable-nls
		# This magic flag enables libintl.
		--with-included-gettext
		# The gettext package provides this library.
		--disable-c++
		--disable-libasprintf
		# No Java until someone cares.
		--disable-java

		$(use_enable static-libs static)
		$(use_enable threads)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	# We only need things in the intl/ subdir.
	emake -C intl
}

multilib_src_install() {
	# We only need things in the intl/ subdir.
	emake DESTDIR="${D}" install -C intl

	gen_usr_ldscript -a intl
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -type f -name "*.la" -delete || die
	fi

	rm -r "${ED}"/usr/share/locale || die

	dodoc AUTHORS ChangeLog NEWS README
}
