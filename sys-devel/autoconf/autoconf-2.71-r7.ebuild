# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/autoconf.git"
	inherit git-r3
else
	# For _beta handling replace with real version number
	MY_PV="${PV}"
	MY_P="${PN}-${MY_PV}"
	#PATCH_TARBALL_NAME="${PN}-2.70-patches-01"

	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/zackweinberg.asc
	inherit verify-sig

	SRC_URI="
		mirror://gnu/${PN}/${MY_P}.tar.xz
		https://alpha.gnu.org/pub/gnu/${PN}/${MY_P}.tar.xz
		verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.xz.sig )
	"
	#SRC_URI+=" https://dev.gentoo.org/~polynomial-c/${PATCH_TARBALL_NAME}.tar.xz"
	S="${WORKDIR}"/${MY_P}

	if ! [[ ${PV} == *_beta* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-zackweinberg )"
fi

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3+"
SLOT="${PV/_*}"
IUSE="emacs"

# for 2.71, our Perl time resolution patch changes our min Perl from 5.6
# (vanilla upstream for 2.71) to 5.8.
BDEPEND+="
	>=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.8
"
RDEPEND="
	${BDEPEND}
	>=sys-devel/autoconf-wrapper-15
	sys-devel/gnuconfig
	!~sys-devel/${P}:2.5
"
[[ ${PV} == 9999 ]] && BDEPEND+=" >=sys-apps/texinfo-4.3"
PDEPEND="emacs? ( app-emacs/autoconf-mode )"

PATCHES=(
	"${FILESDIR}"/${P}-AC_LANG_CALL_C_cxx.patch
	"${FILESDIR}"/${P}-time.patch
	"${FILESDIR}"/${P}-AC_C_BIGENDIAN-lto.patch
	"${FILESDIR}"/${P}-K-R-decls-clang.patch
	"${FILESDIR}"/${P}-make-4.4.patch
	"${FILESDIR}"/${P}-K-R-decls-clang-deux.patch
	"${FILESDIR}"/${P}-cxx11typo.patch
	"${FILESDIR}"/${P}-bash52.patch
)

src_prepare() {
	# usr/bin/libtool is provided by binutils-apple, need gnu libtool
	if [[ ${CHOST} == *-darwin* ]] ; then
		PATCHES+=( "${FILESDIR}"/${PN}-2.71-darwin.patch )
	fi

	# Save timestamp to avoid later makeinfo call
	touch -r doc/{,old_}autoconf.texi || die

	local pdir
	for pdir in "${WORKDIR}"/{upstream_,}patches ; do
		if [[ -d "${pdir}" ]] ; then
			eapply ${pdir}
		fi
	done

	toolchain-autoconf_src_prepare

	# Restore timestamp to avoid makeinfo call
	# We already have an up to date autoconf.info page at this point.
	touch -r doc/{old_,}autoconf.texi || die
}

src_test() {
	emake check
}

src_install() {
	toolchain-autoconf_src_install

	local f
	for f in config.{guess,sub} ; do
		ln -fs ../../gnuconfig/${f} \
			"${ED}"/usr/share/autoconf-*/build-aux/${f} || die
	done
}
