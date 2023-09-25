# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintainers should:
# 1. Join the "Gentoo" project at https://dev.gnupg.org/project/view/27/
# 2. Subscribe to release tasks like https://dev.gnupg.org/T6159
# (find the one for the current release then subscribe to it +
# any subsequent ones linked within so you're covered for a while.)

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..12} )
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/gnupg.asc

inherit distutils-r1 libtool flag-o-matic qmake-utils toolchain-funcs verify-sig

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"
SRC_URI="
	mirror://gnupg/gpgme/${P}.tar.bz2
	verify-sig? ( mirror://gnupg/gpgme/${P}.tar.bz2.sig )
"

LICENSE="GPL-2 LGPL-2.1"
# Please check ABI on each bump, even if SONAMEs didn't change: bug #833355
# Use e.g. app-portage/iwdevtools integration with dev-libs/libabigail's abidiff.
# Subslot: SONAME of each: <libgpgme.libgpgmepp.libqgpgme.FUDGE>
# Bump FUDGE if a release is made which breaks ABI without changing SONAME.
# (Reset to 0 if FUDGE != 0 if libgpgme/libgpgmepp/libqpggme change.)
SLOT="1/11.6.15.2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="common-lisp static-libs +cxx python qt5 test"
RESTRICT="!test? ( test )"
REQUIRED_USE="qt5? ( cxx ) python? ( ${PYTHON_REQUIRED_USE} )"

# - On each bump, update dep bounds on each version from configure.ac!
RDEPEND="
	>=app-crypt/gnupg-2
	>=dev-libs/libassuan-2.5.3:=
	>=dev-libs/libgpg-error-1.36:=
	>=dev-libs/libgpg-error-1.46-r1
	python? ( ${PYTHON_DEPS} )
	qt5? ( dev-qt/qtcore:5 )
"
DEPEND="
	${RDEPEND}
	test? (
		qt5? ( dev-qt/qttest:5 )
	)
"
#doc? ( app-doc/doxygen[dot] )
BDEPEND="
	python? ( dev-lang/swig )
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

src_configure() {
	local languages=()

	# bug #847955
	append-lfs-flags

	if use common-lisp ; then
		languages+=( "cl" )
	fi

	if use cxx ; then
		languages+=( "cpp" )
	fi

	# TODO: qt6? but qt5 and qt5 are mutually exclusive :(
	if use qt5; then
		languages+=( "qt5" )

		#use doc ||
		export DOXYGEN=true
		export MOC="$(qt5_get_bindir)/moc"
	fi

	local myeconfargs=(
		$(use test || echo "--disable-gpgconf-test --disable-gpg-test --disable-gpgsm-test --disable-g13-test")
		--enable-languages="${languages[*]}"
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"

	if use python ; then
		emake -C lang/python prepare

		pushd lang/python > /dev/null || die
		top_builddir="../.." srcdir="." CPP="$(tc-getCPP)" distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	default

	if use python ; then
		pushd lang/python > /dev/null || die
		top_builddir="../.." srcdir="." CPP="$(tc-getCPP)" distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_test() {
	default

	if use python ; then
		distutils-r1_src_test
	fi
}

python_test() {
	emake -C lang/python/tests check \
		PYTHON=${EPYTHON} \
		PYTHONS=${EPYTHON} \
		TESTFLAGS="--python-libdir=${BUILD_DIR}/lib"
}

src_install() {
	default

	if use python ; then
		pushd lang/python > /dev/null || die
		top_builddir="../.." srcdir="." CPP="$(tc-getCPP)" distutils-r1_src_install
		popd > /dev/null || die
	fi

	find "${ED}" -type f -name '*.la' -delete || die

	# Backward compatibility for gentoo
	# (in the past, we had slots)
	dodir /usr/include/gpgme
	dosym ../gpgme.h /usr/include/gpgme/gpgme.h
}
