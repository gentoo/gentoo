# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Small and fast Portage helper tools written in C"
HOMEPAGE="https://wiki.gentoo.org/wiki/Portage-utils"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls static openmp +qmanifest +qtegrity libressl"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/portage-utils.git"
else
	SRC_URI="https://dev.gentoo.org/~grobian/distfiles/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

RDEPEND="
	qmanifest? (
		openmp? (
			|| (
				>=sys-devel/gcc-4.2:*[openmp]
				sys-devel/clang-runtime:*[openmp]
			)
		)
		static? (
			app-crypt/libb2:=[static-libs]
			!libressl? ( dev-libs/openssl:0=[static-libs] )
			libressl? ( dev-libs/libressl:0=[static-libs] )
			sys-libs/zlib:=[static-libs]
			app-crypt/gpgme:=[static-libs]
		)
		!static? (
			app-crypt/libb2:=
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
			sys-libs/zlib:=
			app-crypt/gpgme:=
		)
	)
	qtegrity? (
		openmp? (
			|| (
				>=sys-devel/gcc-4.2:*[openmp]
				sys-devel/clang-runtime:*[openmp]
			)
		)
		static? (
			!libressl? ( dev-libs/openssl:0=[static-libs] )
			libressl? ( dev-libs/libressl:0=[static-libs] )
		)
		!static? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-maintainer-mode \
		--with-eprefix="${EPREFIX}" \
		$(use_enable qmanifest) \
		$(use_enable qtegrity) \
		$(use_enable openmp) \
		$(use_enable static)
}

pkg_postinst() {
	local pvr
	local doshow=
	for pvr in ${REPLACING_VERSIONS} ; do
		[[ ${pvr} != "0.8"[012]* ]] && doshow=true
	done

	if [[ ${doshow} == true ]] ; then
		elog "This version of Portage utils has undergone significant changes."
		elog "Please read the elog manpages for applets like qlop(1) and"
		elog "qfile(1) where argument options have changed."
	fi
}
