# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/diffutils.asc
inherit verify-sig

DESCRIPTION="Tools to make diffs and compare files"
HOMEPAGE="https://www.gnu.org/software/diffutils/"

if [[ ${PV} == *_p* ]] ; then
	# Subscribe to the 'platform-testers' ML to find these.
	# Useful to test on our especially more niche arches and report issues upstream.
	MY_COMMIT="242-d65b"
	MY_P=${PN}-$(ver_cut 1-2).${MY_COMMIT}
	SRC_URI="https://meyering.net/diff/${MY_P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://meyering.net/diff/${MY_P}.tar.xz.sig )"
	S="${WORKDIR}"/${MY_P}
else
	SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="nls"

BDEPEND="
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-diffutils )
"
RDEPEND="
	nls? ( app-i18n/gnulib-l10n )
"

PATCHES=(
	"${FILESDIR}"/${P}-empty-files.patch
	"${FILESDIR}"/${P}-tests-seq.patch
	"${FILESDIR}"/${P}-allocation-crash.patch
)

src_prepare() {
	default

	# Needed because of patches to avoid perl BDEPEND (affects Prefix too)
	touch man/diff.1 || die
}

src_configure() {
	# Disable automagic dependency over libsigsegv; see bug #312351.
	export ac_cv_libsigsegv=no

	# required for >=glibc-2.26, bug #653914
	use elibc_glibc && export gl_cv_func_getopt_gnu=yes

	local myeconfargs=(
		# Interferes with F_S (sets F_S=2)
		--disable-gcc-warnings
		--with-packager="Gentoo"
		--with-packager-version="${PVR}"
		--with-packager-bug-reports="https://bugs.gentoo.org/"
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}
