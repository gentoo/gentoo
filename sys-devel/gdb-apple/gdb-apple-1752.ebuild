# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic toolchain-funcs

APPLE_PV=${PV}
DESCRIPTION="Apple branch of the GNU Debugger, Developer Tools 4.3"
HOMEPAGE="https://sourceware.org/gdb/"
SRC_URI="http://www.opensource.apple.com/darwinsource/tarballs/other/gdb-${APPLE_PV}.tar.gz"

LICENSE="APSL-2 GPL-2"
SLOT="0"

KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"

IUSE="nls"

RDEPEND=">=sys-libs/ncurses-5.2-r2:0=
	sys-libs/readline:0=
	=dev-db/sqlite-3*"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	|| ( >=sys-devel/gcc-apple-4.2.1 sys-devel/llvm:* )"

S=${WORKDIR}/gdb-${APPLE_PV}/src

PATCHES=(
	"${FILESDIR}"/${PN}-no-global-gdbinit.patch
	"${FILESDIR}"/${PN}-768-texinfo.patch
	"${FILESDIR}"/${PN}-1518-darwin8-9.patch
	"${FILESDIR}"/${PN}-1705-darwin8-10.patch
)

src_prepare() {
	default
	[[ ${CHOST} == *-darwin8 ]] && eapply "${FILESDIR}"/${PN}-1518-darwin8.patch

	# use host readline
	sed -i -e '/host_libs/s/readline//' configure.in configure || die
	sed -i \
		-e '/^\(READLINE\|readline\)_/s/=.*$/=/' \
		-e '/^READLINE /s/=.*$/= -lreadline/' \
		gdb/Makefile.in || die
}

src_configure() {
	if tc-is-gcc ; then
		# force gcc-apple, FSF gcc doesn't grok this code
		export CC=${CTARGET:-${CHOST}}-gcc-4.2.1
		export CXX=${CTARGET:-${CHOST}}-g++-4.2.1
	fi

	replace-flags -O? -O2
	econf \
		--disable-werror \
		--disable-debug-symbols-framework \
		$(use_enable nls)
}

src_compile() {
	# unable to work around parallel make issue
	# ignore texinfo issues (version mismatch, to hard to fix or
	# disable)
	emake -j2 MAKEINFOFLAGS="--force"
}

src_install() {
	emake -j2 \
		DESTDIR="${D}" libdir=/nukeme includedir=/nukeme \
		MAKEINFOFLAGS="--force" install || die
	rm -R "${D}"/nukeme || die
	rm -Rf "${ED}"/usr/${CHOST} || die
	mv "${ED}"/usr/bin/gdb "${ED}"/
	rm -f "${ED}"/usr/bin/*
	mv "${ED}"/gdb "${ED}"/usr/bin/
}

pkg_postinst() {
	if [[ ${CHOST} == *-darwin* && ${CHOST#*-darwin} -ge 9 ]] ; then
		ewarn "Due to increased security measures in 10.5 and up, gdb is"
		ewarn "not able to get a mach task port when installed by Prefix"
		ewarn "Portage, unprivileged.  To make gdb fully functional you'll"
		ewarn "have to perform the following steps:"
		ewarn "  % sudo chgrp procmod ${EPREFIX}/usr/bin/gdb"
		ewarn "  % sudo chmod g+s ${EPREFIX}/usr/bin/gdb"
	fi
	if use x86-macos || use x64-macos ; then
		einfo "FSF gdb works on Intel-based OSX platforms, sometimes even"
		einfo "better than gdb-apple.  You can consider installing FSF gdb"
		einfo "instead of gdb-apple, since the FSF version is surely more"
		einfo "advanced than this old 6.8 version modified by Apple."
	fi
}
