# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/autoconf.git"
	inherit git-r3
else
	MY_PN=${PN/-vanilla}
	MY_P=${MY_PN}-${PV}

	# Eric Blake signed 2.69 so use sec-keys/openpgp-keys-m4
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/m4.asc
	inherit verify-sig

	SRC_URI="
		mirror://gnu/${MY_PN}/${MY_P}.tar.xz
		https://dev.gentoo.org/~polynomial-c/dist/${MY_P}-runstatedir_patches.tar.xz
		verify-sig? ( mirror://gnu/${MY_PN}/${MY_P}.tar.xz.sig )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-m4 )"
fi

S="${WORKDIR}"/${MY_P}

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3+"
SLOT="${PV}"
IUSE="emacs"

BDEPEND+="
	>=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.6
"
RDEPEND="
	${BDEPEND}
	>=sys-devel/autoconf-wrapper-13
	!~sys-devel/${P}:2.5
"

[[ ${PV} == 9999 ]] && BDEPEND+=" >=sys-apps/texinfo-4.3"

PDEPEND="emacs? ( app-emacs/autoconf-mode )"

PATCHES=(
	"${FILESDIR}"/${MY_PN}-2.69-perl-5.26.patch
	"${FILESDIR}"/${MY_P}-fix-libtool-test.patch
	"${FILESDIR}"/${MY_PN}-2.69-perl-5.26-2.patch
	"${FILESDIR}"/${MY_P}-make-tests-bash5-compatible.patch

	"${WORKDIR}"/patches/${MY_P}-texinfo.patch
)

TC_AUTOCONF_ENVPREFIX=07

src_unpack() {
	if use verify-sig ; then
		# Needed for downloaded patch (which is unsigned, which is fine)
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.sig}
	fi

	default
}

src_prepare() {
	# usr/bin/libtool is provided by binutils-apple, need gnu libtool
	if [[ ${CHOST} == *-darwin* ]] ; then
		PATCHES+=( "${FILESDIR}"/${MY_PN}-2.61-darwin.patch )
	fi

	# Save timestamp to avoid later makeinfo call
	touch -r doc/{,old_}autoconf.texi || die

	toolchain-autoconf_src_prepare

	# Restore timestamp to avoid makeinfo call
	# We already have an up to date autoconf.info page at this point.
	touch -r doc/{old_,}autoconf.texi || die

	# This version uses recursive makefiles.  As this code is dead by
	# now, and this 'fix' is getting hacked in from the future back into
	# the past, I doubt that the sins committed below will have a wide
	# impact.  Don't copy this code.
	find . \
		 -name Makefile.in \
		 -execdir sed -i '/^pkgdatadir/s/@PACKAGE@/&-vanilla/g' {} + \
		 || die
}
