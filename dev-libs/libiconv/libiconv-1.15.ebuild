# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit libtool toolchain-funcs multilib-minimal usr-ldscript

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="https://www.gnu.org/software/libiconv/"
SRC_URI="mirror://gnu/libiconv/${P}.tar.gz"

LICENSE="LGPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="prefix static-libs"

DEPEND="!sys-libs/glibc
	!userland_GNU? ( !sys-apps/man-pages )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.15-no-gets.patch"
	"${FILESDIR}/${PN}-1.15-no-aix-tweaks.patch"
)

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	if use prefix ; then
		# In Prefix we want to have the same header declaration on every
		# platform, so make configure find that it should do
		# "const char * *inbuf"
		export am_cv_func_iconv=no
	fi
	# Disable NLS support because that creates a circular dependency
	# between libiconv and gettext
	ECONF_SOURCE="${S}" \
	econf \
		--docdir="\$(datarootdir)/doc/${PF}/html" \
		--disable-nls \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	use static-libs || find "${ED}" -name 'lib*.la' -delete

	# Install in /lib as utils installed in /lib like gnutar
	# can depend on this
	gen_usr_ldscript -a iconv charset

	# If we have a GNU userland, we probably have sys-apps/man-pages
	# installed, which means we want to rename our copies #503162.
	# The use of USELAND=GNU is kind of a hack though ...
	if use userland_GNU ; then
		cd "${ED}"/usr/share/man || die
		local f
		for f in man*/*.[0-9] ; do
			mv "${f}" "${f%/*}/${PN}-${f#*/}" || die
		done
	fi
}
