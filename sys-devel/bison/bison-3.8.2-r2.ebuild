# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/bison.asc
inherit flag-o-matic multiprocessing verify-sig

DESCRIPTION="A general-purpose (yacc-compatible) parser generator"
HOMEPAGE="https://www.gnu.org/software/bison/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="examples nls static test"
RESTRICT="!test? ( test )"

# gettext _IS_ required in RDEPEND because >=bison-3.7 links against
# libtextstyle.so!!! (see bug #740754)
DEPEND="
	>=sys-devel/m4-1.4.16
	>=sys-devel/gettext-0.21
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-alternatives/lex
	test? ( dev-lang/perl )
	verify-sig? ( sec-keys/openpgp-keys-bison )
"
PDEPEND="app-alternatives/yacc"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO ) # ChangeLog-2012 ChangeLog-1998 PACKAGING README-alpha README-release

src_prepare() {
	# Old logic when we needed to patch configure.ac
	# Keeping in case it's useful for future

	# Record date to avoid 'config.status --recheck' & regen of 'tests/package.m4'
	#touch -r configure.ac old.configure.ac || die
	#touch -r configure old.configure || die

	#eapply "${WORKDIR}"/patches
	#default

	# Restore date after patching
	#touch -r old.configure.ac configure.ac || die
	#touch -r old.configure configure || die

	# The makefiles make the man page depend on the configure script
	# which we patched above.  Touch it to prevent regeneration.
	#touch doc/bison.1 || die #548778 #538300#9

	default

	# Avoid regenerating the info page when the timezone is diff. #574492
	sed -i '2iexport TZ=UTC' build-aux/mdate-sh || die
}

src_configure() {
	use static && append-ldflags -static

	local myeconfargs=(
		$(use_enable nls)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake check TESTSUITEFLAGS="--jobs=$(get_makeopts_jobs)"
}

src_install() {
	default

	# These are owned by app-alternatives/yacc
	mv "${ED}"/usr/bin/yacc{,.bison} || die
	mv "${ED}"/usr/share/man/man1/yacc{,.bison}.1 || die

	# We do not need liby.a
	rm -r "${ED}"/usr/lib* || die

	# Examples are about 200K, so let's make them optional still for now.
	if ! use examples ; then
		rm -r "${ED}"/usr/share/doc/${PF}/examples/ || die
	fi
}

pkg_postinst() {
	# ensure to preserve the symlinks before app-alternatives/yacc
	# is installed
	if [[ ! -h ${EROOT}/usr/bin/yacc ]]; then
		if [[ -e ${EROOT}/usr/bin/yacc ]] ; then
			# bug #886123
			ewarn "${EROOT}/usr/bin/yacc exists but is not a symlink."
			ewarn "This is expected during Prefix bootstrap and unusual otherwise."
			ewarn "Moving away unexpected ${EROOT}/usr/bin/yacc to .bak."
			mv "${EROOT}/usr/bin/yacc" "${EROOT}/usr/bin/yacc.bak" || die
		fi

		ln -s yacc.bison "${EROOT}/usr/bin/yacc" || die
	fi
}
