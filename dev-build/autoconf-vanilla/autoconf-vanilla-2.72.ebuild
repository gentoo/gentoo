# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please do not apply any patches which affect the generated output from
# `autoconf`, as this package is used to submit patches upstream.

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/autoconf.git"
	inherit git-r3
else
	MY_PN=${PN/-vanilla}
	# For _beta handling replace with real version number
	MY_PV="${PV}"
	MY_P="${MY_PN}-${MY_PV}"
	#PATCH_TARBALL_NAME="${MY_PN}-2.70-patches-01"

	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/zackweinberg.asc
	inherit verify-sig

	SRC_URI="
		mirror://gnu/${MY_PN}/${MY_P}.tar.xz
		https://alpha.gnu.org/pub/gnu/${MY_PN}/${MY_P}.tar.xz
		https://meyering.net/ac/${MY_P}.tar.xz
		verify-sig? ( mirror://gnu/${PN}/${MY_P}.tar.xz.sig )
	"
	 S="${WORKDIR}"/${MY_P}

	if [[ ${PV} != *_beta* ]] && ! [[ $(ver_cut 3) =~ [a-z] ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-zackweinberg )"
fi

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3+"
SLOT="$(ver_cut 1-2)"
IUSE="emacs"

BDEPEND+="
	>=dev-lang/perl-5.10
	>=sys-devel/m4-1.4.16
"
RDEPEND="
	${BDEPEND}
	>=dev-build/autoconf-wrapper-15
	!~dev-build/${P}:2.5
	sys-devel/gnuconfig
"
[[ ${PV} == 9999 ]] && BDEPEND+=" >=sys-apps/texinfo-4.3"
PDEPEND="emacs? ( app-emacs/autoconf-mode )"

PATCHES=(
	"${FILESDIR}"/"${MY_P}"-conflicts.patch
)

TC_AUTOCONF_ENVPREFIX=07

src_prepare() {
	if [[ ${PV} == *9999 ]] ; then
		# Avoid the "dirty" suffix in the git version by generating it
		# before we run later stages which might modify source files.
		local ver=$(./build-aux/git-version-gen .tarball-version)
		echo "${ver}" > .tarball-version || die

		autoreconf -f -i || die
	fi

	# usr/bin/libtool is provided by binutils-apple, need gnu libtool
	if [[ ${CHOST} == *-darwin* ]] ; then
		PATCHES+=( "${FILESDIR}"/${MY_PN}-2.71-darwin.patch )
	fi

	# Save timestamp to avoid later makeinfo call
	touch -r doc/{,old_}autoconf.texi || die

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
