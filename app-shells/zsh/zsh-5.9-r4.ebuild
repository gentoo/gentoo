# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic prefix

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

SRC_URI="https://www.zsh.org/pub/${P}.tar.xz
	https://www.zsh.org/pub/old/${P}.tar.xz
	mirror://sourceforge/${PN}/${P}.tar.xz
	doc? (
		https://www.zsh.org/pub/${P}-doc.tar.xz
		mirror://sourceforge/${PN}/${P}-doc.tar.xz
	)"

DESCRIPTION="UNIX Shell similar to the Korn shell"
HOMEPAGE="https://www.zsh.org/"

LICENSE="ZSH gdbm? ( GPL-2 )"
SLOT="0"
IUSE="caps debug doc examples gdbm maildir pcre static valgrind"

# Next release should use pcre2: https://github.com/zsh-users/zsh/commit/b62e911341c8ec7446378b477c47da4256053dc0
RDEPEND="
	>=sys-libs/ncurses-5.1:0=
	static? ( >=sys-libs/ncurses-5.7-r4:0=[static-libs] )
	caps? ( sys-libs/libcap )
	pcre? (
		>=dev-libs/libpcre-3.9
		static? ( >=dev-libs/libpcre-3.9[static-libs] )
	)
	gdbm? (
		sys-libs/gdbm:=
		static? ( sys-libs/gdbm:=[static-libs] )
	)
"
DEPEND="sys-apps/groff
	valgrind? ( dev-util/valgrind )
	${RDEPEND}"
PDEPEND="
	examples? ( app-doc/zsh-lovers )
"
if [[ ${PV} == *9999 ]] ; then
	DEPEND+=" app-text/yodl
		doc? (
			sys-apps/texinfo
			app-text/texi2html
			virtual/latex-base
		)"
fi

PATCHES=(
	# Add openrc specific options for init.d completion
	"${FILESDIR}"/${PN}-5.3-init.d-gentoo.diff
	# Please refer gentoo bug #833981
	"${FILESDIR}"/${PN}-5.9-musl-V09datetime-test-fix.patch
	# bug #869539
	"${FILESDIR}"/${PN}-5.9-clang-15-configure.patch
	"${FILESDIR}"/${PN}-5.9-do-not-use-egrep-in-tests.patch
)

src_prepare() {
	if [[ ${PV} != *9999 ]]; then
		# fix zshall problem with soelim
		ln -s Doc man1 || die
		mv Doc/zshall.1 Doc/zshall.1.soelim || die
		soelim Doc/zshall.1.soelim > Doc/zshall.1 || die
	fi

	default

	hprefixify configure.ac
	if [[ ${PV} == *9999 ]] ; then
		sed -i "/^VERSION=/s@=.*@=${PV}@" Config/version.mk || die
	fi
	eautoreconf
}

src_configure() {
	local myconf=(
		--bindir="${EPREFIX}"/bin
		--libdir="${EPREFIX}"/usr/$(get_libdir)
		--enable-etcdir="${EPREFIX}"/etc/zsh
		--enable-runhelpdir="${EPREFIX}"/usr/share/zsh/${PV%_*}/help
		--enable-fndir="${EPREFIX}"/usr/share/zsh/${PV%_*}/functions
		--enable-site-fndir="${EPREFIX}"/usr/share/zsh/site-functions
		--enable-function-subdirs
		--with-tcsetpgrp
		--enable-multibyte
		--with-term-lib='tinfow ncursesw'
		$(use_enable maildir maildir-support)
		$(use_enable pcre)
		$(use_enable caps cap)
		$(use_enable gdbm)
		$(use_enable valgrind zsh-valgrind)
	)

	if use static ; then
		myconf+=( --disable-dynamic )
		append-ldflags -static
	fi
	if use debug ; then
		myconf+=(
			--enable-zsh-debug
			--enable-zsh-mem-debug
			--enable-zsh-mem-warning
			--enable-zsh-secure-free
			--enable-zsh-hash-debug
		)
	fi

	if [[ ${CHOST} == *-darwin* ]]; then
		myconf+=( --enable-libs=-liconv )
		append-ldflags -Wl,-x
	fi

	econf "${myconf[@]}"

	if use static ; then
		# compile all modules statically, see Bug #27392
		# removed cap and curses because linking failes
		sed -e "s,link=no,link=static,g" \
			-e "/^name=zsh\/cap/s,link=static,link=no," \
			-e "/^name=zsh\/curses/s,link=static,link=no," \
			-i "${S}"/config.modules || die
		if ! use gdbm ; then
			sed -i '/^name=zsh\/db\/gdbm/s,link=static,link=no,' \
				"${S}"/config.modules || die
		fi
	fi
}

src_compile() {
	default

	if [[ ${PV} == *9999 ]] && use doc ; then
		emake -C Doc everything
	fi
}

src_test() {
	# Fixes tests A03quoting.ztst B03print.ztst on musl
	# Please refer:
	# https://www.zsh.org/mla/workers/2021/msg00805.html
	# Test E02xtrace fails on musl, so we are removing it.
	# Closes: https://bugs.gentoo.org/833981
	if use elibc_musl ; then
		unset LC_ALL
		unset LC_COLLATE
		unset LC_NUMERIC
		unset LC_MESSAGES
		unset LANG
		rm "${S}"/Test/E02xtrace.ztst || die
	fi

	# Breaks tests if inherited from environment.
	unset TMPPREFIX

	addpredict /dev/ptmx
	local i
	for i in C02cond.ztst V08zpty.ztst X02zlevi.ztst Y01completion.ztst Y02compmatch.ztst Y03arguments.ztst ; do
		rm "${S}"/Test/${i} || die
	done
	emake check
}

src_install() {
	emake DESTDIR="${D}" install $(usex doc "install.info" "")

	insinto /etc/zsh
	export PREFIX_QUOTE_CHAR='"' PREFIX_EXTRA_REGEX="/EUID/s,0,${EUID},"
	newins "$(prefixify_ro "${FILESDIR}"/zprofile-4)" zprofile

	keepdir /usr/share/zsh/site-functions
	insinto /usr/share/zsh/${PV%_*}/functions/Prompts
	newins "${FILESDIR}"/prompt_gentoo_setup-1 prompt_gentoo_setup

	local i

	# install miscellaneous scripts (bug #54520)
	sed -e "s:/usr/local/bin/perl:${EPREFIX}/usr/bin/perl:g" \
		-e "s:/usr/local/bin/zsh:${EPREFIX}/bin/zsh:g" \
		-i {Util,Misc}/* || die
	for i in Util Misc ; do
		insinto /usr/share/zsh/${PV%_*}/${i}
		doins ${i}/*
	done

	# install header files (bug #538684)
	insinto /usr/include/zsh
	doins config.h Src/*.epro
	for i in Src/{zsh.mdh,*.h} ; do
		sed -e 's@\.\./config\.h@config.h@' \
			-e 's@#\(\s*\)include "\([^"]\+\)"@#\1include <zsh/\2>@' \
			-i "${i}"
		doins "${i}"
	done

	dodoc ChangeLog* META-FAQ NEWS README config.modules

	if use doc ; then
		pushd "${WORKDIR}/${PN}-${PV%_*}" >/dev/null
		dodoc Doc/zsh.{dvi,pdf}
		docinto html
		dodoc Doc/*.html
		popd >/dev/null
	fi

	docinto StartupFiles
	dodoc StartupFiles/z*
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		echo
		elog "If you want to enable Portage completions and Gentoo prompt,"
		elog "emerge app-shells/gentoo-zsh-completions and add"
		elog "	autoload -U compinit promptinit"
		elog "	compinit"
		elog "	promptinit; prompt gentoo"
		elog "to your ~/.zshrc"
		echo
		elog "Also, if you want to enable cache for the completions, add"
		elog "	zstyle ':completion::complete:*' use-cache 1"
		elog "to your ~/.zshrc"
		echo
		elog "Note that a system zprofile startup file is installed. This will override"
		elog "PATH and possibly other variables that a user may set in ~/.zshenv."
		elog "Custom PATH settings and similar overridden variables can be moved to ~/.zprofile"
		elog "or other user startup files that are sourced after the system zprofile."
		echo
		elog "If PATH must be set in ~/.zshenv to affect things like non-login ssh shells,"
		elog "one method is to use a separate path-setting file that is conditionally sourced"
		elog "in ~/.zshenv and also sourced from ~/.zprofile. For more information, see the"
		elog "zshenv example in ${EROOT}/usr/share/doc/${PF}/StartupFiles/."
		echo
		elog "See https://wiki.gentoo.org/wiki/Zsh/HOWTO for more introduction documentation."
		echo
	fi
}
