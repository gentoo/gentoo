# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools elisp-common flag-o-matic

DESCRIPTION="Any to PostScript filter"
HOMEPAGE="https://www.gnu.org/software/a2ps/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	cjk? ( mirror://gentoo/${P}-ja_nls.patch.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cjk emacs latex nls static-libs vanilla"

RESTRICT=test

RDEPEND="app-text/ghostscript-gpl
	app-text/libpaper:=
	>=app-text/psutils-1.17
	app-text/wdiff
	>=sys-apps/coreutils-6.10-r1
	emacs? ( >=app-editors/emacs-23.1:* )
	latex? ( virtual/latex-base )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	>=dev-util/gperf-2.7.2
	virtual/yacc
	nls? ( sys-devel/gettext )"

SITEFILE=50${PN}-gentoo.el

S=${WORKDIR}/${PN}-${PV:0:4}

src_prepare() {
	default

	eapply "${FILESDIR}"/${PN}-4.13c-locale-gentoo.diff
	use vanilla || eapply -p0 "${FILESDIR}"/${PN}-4.13-stdout.diff
	if use cjk; then
		eapply "${WORKDIR}"/${P}-ja_nls.patch
		# bug #335803
		eapply -p0 "${FILESDIR}"/${P}-ja-cleanup.patch
	else
		eapply "${FILESDIR}"/${P}-cleanup.patch
	fi

	# fix fnmatch replacement, bug #134546
	eapply "${FILESDIR}"/${PN}-4.13c-fnmatch-replacement.patch

	# bug #122026
	eapply "${FILESDIR}"/${P}-psset.patch

	# fix emacs printing, bug #114627
	eapply "${FILESDIR}"/a2ps-4.13c-emacs.patch

	# fix chmod error, #167670
	eapply "${FILESDIR}"/a2ps-4.13-manpage-chmod.patch

	# add configure check for mempcpy, bug 216588
	eapply "${FILESDIR}"/${P}-check-mempcpy.patch

	# fix compilation error due to invalid stpcpy() prototype, bug 216588
	eapply -p0 "${FILESDIR}"/${P}-fix-stpcpy-proto.patch

	# fix compilation error due to obstack.h issue, bug 269638
	eapply "${FILESDIR}"/${P}-ptrdiff_t.patch

	# fix compilation error due to texinfo 5.x, bug 482748
	eapply "${FILESDIR}"/${P}-texinfo-5.x.patch

	# fix CVE-2014-0466, bug 506352
	eapply "${FILESDIR}"/${P}-CVE-2014-0466.patch

	# fix CVE-2001-1593, bug 507024
	eapply "${FILESDIR}"/${P}-CVE-2001-1593.patch

	# specify encoding explicitly, bug #695918
	eapply "${FILESDIR}"/${P}-texinfo-6.7-encoding.patch

	# fix building with sys-devel/automake >= 1.12, bug 420503
	rm -f {.,ogonkify}/aclocal.m4 || die
	sed -i \
		-e '/^AM_C_PROTOTYPES/d' \
		-e '/^AUTOMAKE_OPTIONS.*ansi2knr/d' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:' \
		configure.in {contrib/sample,lib,src}/Makefile.am m4/protos.m4 || die

	eautoreconf
}

src_configure() {
	append-cppflags -DPROTOTYPES #420503

	local myconf="COM_netscape=no COM_acroread=no"

	use emacs || myconf="${myconf} EMACS=no"
	use latex || myconf="${myconf} COM_latex=no"

	export LANG=C LC_ALL=C

	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--sysconfdir="${EPREFIX}"/etc/a2ps \
		$(use_enable nls) \
		${myconf}
}

src_compile() {
	# parallel make b0rked
	emake -j1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		lispdir="${EPREFIX}${SITELISP}"/${PN} \
		install

	newdoc "${ED}"/usr/share/a2ps/README README.a2ps
	newdoc "${ED}"/usr/share/a2ps/ppd/README README.a2ps.ppd
	newdoc "${ED}"/usr/share/ogonkify/README README.ogonkify

	rm -f "${ED}"/usr/share/{a2ps,a2ps/ppd,ogonkify}/README || die

	find "${ED}" -name '*.la' -delete || die

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} || die
	fi

	dodoc ANNOUNCE AUTHORS ChangeLog FAQ NEWS README* THANKS TODO
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
