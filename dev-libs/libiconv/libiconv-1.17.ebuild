# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="https://www.gnu.org/software/libiconv/"
SRC_URI="mirror://gnu/libiconv/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="prefix static-libs"

DEPEND="!sys-libs/glibc
	!sys-libs/musl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.16-fix-link-install.patch"
)

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

	# We need to rename our copies, bug #503162
	cd "${ED}"/usr/share/man || die
	local f
	for f in man*/*.[0-9] ; do
		mv "${f}" "${f%/*}/${PN}-${f#*/}" || die
	done
}
