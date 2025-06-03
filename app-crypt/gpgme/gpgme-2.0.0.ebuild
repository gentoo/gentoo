# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintainers should:
# 1. Join the "Gentoo" project at https://dev.gnupg.org/project/view/27/
# 2. Subscribe to release tasks like https://dev.gnupg.org/T6159
# (find the one for the current release then subscribe to it +
# any subsequent ones linked within so you're covered for a while.)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gnupg.asc

# in-source builds are not supported:
# * https://dev.gnupg.org/T6313#166339
# * https://dev.gnupg.org/T6673#174545
inherit libtool flag-o-matic out-of-source verify-sig

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"
SRC_URI="
	mirror://gnupg/gpgme/${P}.tar.bz2
	verify-sig? ( mirror://gnupg/gpgme/${P}.tar.bz2.sig )
"

LICENSE="GPL-2 LGPL-2.1"
# Please check ABI on each bump, even if SONAMEs didn't change: bug #833355
# Use e.g. app-portage/iwdevtools integration with dev-libs/libabigail's abidiff.
# Subslot: SONAME of each: <libgpgme.FUDGE>
# Bump FUDGE if a release is made which breaks ABI without changing SONAME.
# (Reset to 0 if FUDGE != 0 if libgpgme changes.)
SLOT="1/45.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="common-lisp static-libs test"
RESTRICT="!test? ( test )"

# On each bump, update dep bounds on each version from configure.ac!
RDEPEND="
	>=app-crypt/gnupg-2
	>=dev-libs/libassuan-2.5.3:=
	>=dev-libs/libgpg-error-1.46-r1:=
"
DEPEND="${RDEPEND}"
#doc? ( app-text/doxygen[dot] )
BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-gnupg )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.18.0-tests-start-stop-agent-use-command-v.patch
)

src_prepare() {
	default

	elibtoolize

	# bug #697456
	addpredict /run/user/$(id -u)/gnupg

	local MAX_WORKDIR=66
	if use test && [[ "${#WORKDIR}" -gt "${MAX_WORKDIR}" ]]; then
		eerror "Unable to run tests as WORKDIR='${WORKDIR}' is longer than ${MAX_WORKDIR} which causes failure!"
		die "Could not run tests as requested with too-long WORKDIR."
	fi

	# Make best effort to allow longer PORTAGE_TMPDIR
	# as usock limitation fails build/tests
	ln -s "${P}" "${WORKDIR}/b" || die
	S="${WORKDIR}/b"
}

my_src_configure() {
	# bug #847955
	append-lfs-flags

	cd "${BUILD_DIR}" || die

	local languages=(
		$(usev common-lisp 'cl')
	)

	local myeconfargs=(
		$(use test || echo "--disable-gpgconf-test --disable-gpg-test --disable-gpgsm-test --disable-g13-test")
		--enable-languages="${languages[*]}"
		$(use_enable static-libs static)
		GPGRT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpgrt-config"
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

my_src_compile() {
	cd "${BUILD_DIR}" || die

	emake
}

my_src_test() {
	cd "${BUILD_DIR}" || die

	emake check
}

my_src_install() {
	einstalldocs

	cd "${BUILD_DIR}" || die

	emake DESTDIR="${D}" install

	find "${ED}" -type f -name '*.la' -delete || die

	# Backward compatibility for gentoo
	# (in the past, we had slots)
	dodir /usr/include/gpgme
	dosym -r /usr/include/gpgme.h /usr/include/gpgme/gpgme.h
}
