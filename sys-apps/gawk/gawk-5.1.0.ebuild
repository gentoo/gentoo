# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib

DESCRIPTION="GNU awk pattern-matching language"
HOMEPAGE="https://www.gnu.org/software/gawk/gawk.html"
SRC_URI="mirror://gnu/gawk/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="forced-sandbox mpfr nls readline"

RDEPEND="
	dev-libs/gmp:0=
	mpfr? ( dev-libs/mpfr:0= )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-apps/texinfo-6.7
	>=sys-devel/bison-3.5.4
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	# use symlinks rather than hardlinks, and disable version links
	sed -i \
		-e '/^LN =/s:=.*:= $(LN_S):' \
		-e '/install-exec-hook:/s|$|\nfoo:|' \
		Makefile.in doc/Makefile.in || die
	sed -i '/^pty1:$/s|$|\n_pty1:|' test/Makefile.in || die #413327
	# fix standards conflict on Solaris
	if [[ ${CHOST} == *-solaris* ]] ; then
		sed -i \
			-e '/\<_XOPEN_SOURCE\>/s/1$/600/' \
			-e '/\<_XOPEN_SOURCE_EXTENDED\>/s/1//' \
			extension/inplace.c || die
	fi

	if use forced-sandbox ; then
		# Upstream doesn't want to add a configure flag for this.
		# https://lists.gnu.org/archive/html/bug-sed/2018-03/msg00001.html
		sed -i \
			-e '/^int do_flags = false;/s:false:DO_SANDBOX:' \
			main.c || die
		# Make sure the sed took.
		grep -q '^int do_flags = DO_SANDBOX;' main.c || die "forcing sandbox failed"
	fi
}

src_configure() {
	export ac_cv_libsigsegv=no
	local myeconfargs=(
		--libexec='$(libdir)/misc'
		$(use_with mpfr)
		$(use_enable nls)
		$(use_with readline)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	rm -rf README_d # automatic dodocs barfs
	default

	# Install headers
	insinto /usr/include/awk
	doins *.h
	rm "${ED}"/usr/include/awk/config.h || die
}

src_test() {
	if use forced-sandbox ; then
		ewarn "Tests disabled as they don't account for this mode."
		return
	fi
	default
}

pkg_postinst() {
	# symlink creation here as the links do not belong to gawk, but to any awk
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk ; then
		eselect awk update ifunset
	else
		local l
		for l in "${EROOT}"/usr/share/man/man1/gawk.1* "${EROOT}"/usr/bin/gawk ; do
			if [[ -e ${l} ]] && ! [[ -e ${l/gawk/awk} ]] ; then
				ln -s "${l##*/}" "${l/gawk/awk}" || die
			fi
		done
		if ! [[ -e ${EROOT}/bin/awk ]] ; then
			ln -s "../usr/bin/gawk" "${EROOT}/bin/awk" || die
		fi
	fi
}

pkg_postrm() {
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk ; then
		eselect awk update ifunset
	fi
}
