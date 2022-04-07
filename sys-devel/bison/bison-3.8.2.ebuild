# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/bison.asc
inherit flag-o-matic verify-sig

DESCRIPTION="A general-purpose (yacc-compatible) parser generator"
HOMEPAGE="https://www.gnu.org/software/bison/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.xz.sig )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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
	sys-devel/flex
	test? ( dev-lang/perl )
	verify-sig? ( sec-keys/openpgp-keys-bison )
"

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

src_install() {
	default

	# This one is installed by dev-util/yacc
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
	local f="${EROOT}/usr/bin/yacc"
	if [[ ! -e ${f} ]] ; then
		ln -s yacc.bison "${f}"
	fi
}

pkg_postrm() {
	# clean up the dead symlink when we get unmerged #377469
	local f="${EROOT}/usr/bin/yacc"
	if [[ -L ${f} && ! -e ${f} ]] ; then
		rm -f "${f}"
	fi
}
