# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gettext.asc
inherit multilib-minimal verify-sig

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="https://www.gnu.org/software/libiconv/"
SRC_URI="
	mirror://gnu/libiconv/${P}.tar.gz
	verify-sig? ( mirror://gnu/${PN}/${P}.tar.gz.sig )
"

LICENSE="LGPL-2.1+ GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="prefix static-libs"

DEPEND="
	!sys-libs/glibc
	!sys-libs/musl
"
RDEPEND="${DEPEND}"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.18-fix-link-install.patch
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
		--cache-file="${BUILD_DIR}"/config.cache \
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
