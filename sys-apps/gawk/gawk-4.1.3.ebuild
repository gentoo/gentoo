# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs multilib

DESCRIPTION="GNU awk pattern-matching language"
HOMEPAGE="https://www.gnu.org/software/gawk/gawk.html"
SRC_URI="mirror://gnu/gawk/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="mpfr nls readline"

RDEPEND="mpfr? ( dev-libs/mpfr:0= )
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	# use symlinks rather than hardlinks, and disable version links
	sed -i \
		-e '/^LN =/s:=.*:= $(LN_S):' \
		-e '/install-exec-hook:/s|$|\nfoo:|' \
		Makefile.in doc/Makefile.in || die
	sed -i '/^pty1:$/s|$|\n_pty1:|' test/Makefile.in #413327
	# disable pointless build time hack that breaks cross-compiling #493362
	sed -i \
		-e '/check-recursive all-recursive: check-for-shared-lib-support/d' \
		extension/Makefile.in || die

	EPATCH_OPTS="-Z" \
	epatch "${FILESDIR}/${P}-bsd_configure_readline.patch" #507468
}

src_configure() {
	export ac_cv_libsigsegv=no
	econf \
		--libexec='$(libdir)/misc' \
		$(use_with mpfr) \
		$(use_enable nls) \
		$(use_with readline)
}

src_install() {
	rm -rf README_d # automatic dodocs barfs
	default

	# Install headers
	insinto /usr/include/awk
	doins *.h || die
	rm "${ED}"/usr/include/awk/config.h || die
}

pkg_postinst() {
	# symlink creation here as the links do not belong to gawk, but to any awk
	if has_version app-admin/eselect \
			&& has_version app-eselect/eselect-awk ; then
		eselect awk update ifunset
	else
		local l
		for l in "${EROOT}"usr/share/man/man1/gawk.1* "${EROOT}"usr/bin/gawk; do
			[[ -e ${l} && ! -e ${l/gawk/awk} ]] && ln -s "${l##*/}" "${l/gawk/awk}"
		done
		[[ ! -e ${EROOT}bin/awk ]] && ln -s "../usr/bin/gawk" "${EROOT}bin/awk"
	fi
}

pkg_postrm() {
	if has_version app-admin/eselect \
			&& has_version app-eselect/eselect-awk ; then
		eselect awk update ifunset
	fi
}
