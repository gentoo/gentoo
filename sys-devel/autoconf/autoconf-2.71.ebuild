# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/autoconf.git"
	inherit git-r3
else
	# For _beta handling replace with real version number
	MY_PV="${PV}"
	MY_P="${PN}-${MY_PV}"
	#PATCH_TARBALL_NAME="${PN}-2.70-patches-01"
	SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.xz -> ${P}.tar.xz
		https://alpha.gnu.org/pub/gnu/${PN}/${MY_P}.tar.xz -> ${P}.tar.xz"
	#SRC_URI+=" https://dev.gentoo.org/~polynomial-c/${PATCH_TARBALL_NAME}.tar.xz"
	[[ "${PV}" == *_beta* ]] || \
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
	S="${WORKDIR}/${MY_P}"
fi

inherit toolchain-autoconf

DESCRIPTION="Used to create autoconfiguration files"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"

LICENSE="GPL-3"
SLOT="${PV/_*}"
IUSE="emacs"

BDEPEND=">=sys-devel/m4-1.4.16
	>=dev-lang/perl-5.6"
RDEPEND="${BDEPEND}
	>=sys-devel/autoconf-wrapper-15
	sys-devel/gnuconfig
	!~sys-devel/${P}:2.5"
[[ ${PV} == "9999" ]] && BDEPEND+=" >=sys-apps/texinfo-4.3"
PDEPEND="emacs? ( app-emacs/autoconf-mode )"

src_prepare() {
	# usr/bin/libtool is provided by binutils-apple, need gnu libtool
	if [[ ${CHOST} == *-darwin* ]] ; then
		PATCHES+=( "${FILESDIR}"/${PN}-2.61-darwin.patch )
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

src_install() {
	toolchain-autoconf_src_install

	local f
	for f in config.{guess,sub} ; do
		ln -fs ../../gnuconfig/${f} \
			"${ED}"/usr/share/autoconf-*/build-aux/${f} || die
	done
}
