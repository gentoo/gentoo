# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="Small and fast Portage helper tools written in C"
HOMEPAGE="https://wiki.gentoo.org/wiki/Portage-utils"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls static openmp +qmanifest"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/portage-utils.git"
else
	SRC_URI="mirror://gentoo/${P}.tar.xz
		https://dev.gentoo.org/~grobian/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~hppa ~m68k ~mips ~ppc64 ~s390 ~sh ~sparc ~ppc-aix ~x64-cygwin ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

RDEPEND="dev-libs/iniparser:0"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	static? ( dev-libs/iniparser:0[static-libs] )
	qmanifest? (
		openmp? (
			|| (
				>=sys-devel/gcc-4.2:*[openmp]
				sys-devel/clang-runtime:*[openmp]
			)
		)
		app-crypt/libb2
		dev-libs/openssl:0=
		sys-libs/zlib
		app-crypt/gpgme
	)
	"

src_prepare() {
	default
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--with-eprefix="${EPREFIX}" \
		$(use_enable qmanifest) \
		$(use_enable openmp)
}

pkg_postinst() {
	local pvr
	local doshow=
	for pvr in ${REPLACING_VERSIONS} ; do
		[[ ${pvr} != "0.8"[01]* ]] && doshow=true
	done

	if [[ ${doshow} == true ]] ; then
		elog "This is a pre-release of the next version of Portage Utils"
		elog "which has undergone significant changes.  Please read the"
		elog "manpages for applets like qlop(1) where argument options have"
		elog "changed."
		elog "There will likely be changes to come before 0.80, and bugs are"
		elog "possible.  Please report the latter, and request the former if"
		elog "applicable."
	fi
}
