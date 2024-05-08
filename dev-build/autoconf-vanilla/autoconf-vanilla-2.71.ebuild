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
	MY_P=${MY_PN}-${PV}

	SRC_URI="
		mirror://gnu/${MY_PN}/${MY_P}.tar.xz
		https://alpha.gnu.org/pub/gnu/${MY_PN}/${MY_P}.tar.xz
	"

	if ! [[ ${PV} == *_beta* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
	S="${WORKDIR}"/${MY_P}
fi

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3+"
SLOT="${PV/_*}"
IUSE="emacs"

# for 2.71, our Perl time resolution patch changes our min Perl from 5.6
# (vanilla upstream for 2.71) to 5.8.
BDEPEND=">=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.8"
RDEPEND="${BDEPEND}
	>=dev-build/autoconf-wrapper-15
	sys-devel/gnuconfig
	!~dev-build/${P}:2.5"
[[ ${PV} == 9999 ]] && BDEPEND+=" >=sys-apps/texinfo-4.3"
PDEPEND="emacs? ( app-emacs/autoconf-mode )"

PATCHES=(
	"${FILESDIR}"/${MY_P}-AC_LANG_CALL_C_cxx.patch
	"${FILESDIR}"/${MY_P}-time.patch
	"${FILESDIR}"/${MY_P}-make-4.4.patch
	"${FILESDIR}"/"${MY_P}"-conflicts.patch
)

TC_AUTOCONF_ENVPREFIX=07

src_prepare() {
	# usr/bin/libtool is provided by binutils-apple, need gnu libtool
	if [[ ${CHOST} == *-darwin* ]] ; then
		PATCHES+=( "${FILESDIR}"/${MY_PN}-2.71-darwin.patch )
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
