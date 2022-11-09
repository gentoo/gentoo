# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common flag-o-matic

DESCRIPTION="Any to PostScript filter"
HOMEPAGE="https://www.gnu.org/software/a2ps/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz
	cjk? ( mirror://gentoo/${P}-ja_nls.patch.gz )"
S="${WORKDIR}/${PN}-${PV:0:4}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cjk emacs latex nls static-libs vanilla"

RESTRICT="test"

RDEPEND="app-text/ghostscript-gpl
	app-text/libpaper:=
	>=app-text/psutils-1.17
	app-text/wdiff
	>=sys-apps/coreutils-6.10-r1
	emacs? ( >=app-editors/emacs-23.1:* )
	latex? ( virtual/latex-base )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-util/gperf-2.7.2
	virtual/yacc
	nls? ( sys-devel/gettext )"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${PN}-4.13c-locale-gentoo.diff
	"${FILESDIR}"/${PN}-4.13c-fnmatch-replacement.patch
	"${FILESDIR}"/${P}-psset.patch
	"${FILESDIR}"/${PN}-4.13c-emacs.patch
	"${FILESDIR}"/${PN}-4.13-manpage-chmod.patch
	"${FILESDIR}"/${P}-check-mempcpy.patch
	"${FILESDIR}"/${P}-fix-stpcpy-proto.patch
	"${FILESDIR}"/${P}-ptrdiff_t.patch
	"${FILESDIR}"/${P}-texinfo-5.x.patch
	"${FILESDIR}"/${P}-CVE-2014-0466.patch
	"${FILESDIR}"/${P}-CVE-2001-1593.patch
	"${FILESDIR}"/${P}-texinfo-6.7-encoding.patch
	"${FILESDIR}"/${P}-function-decl.patch
	"${FILESDIR}"/${P}-configure.ac.patch
)

src_prepare() {
	default

	use vanilla || eapply "${FILESDIR}"/${P}-stdout.patch
	if use cjk; then
		eapply "${WORKDIR}"/${P}-ja_nls.patch
		# bug #335803
		eapply -p0 "${FILESDIR}"/${P}-ja-cleanup.patch
	else
		eapply "${FILESDIR}"/${P}-cleanup.patch
	fi

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

	export LANG=C LC_ALL=C

	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--sysconfdir="${EPREFIX}"/etc/a2ps \
		$(use_enable nls) \
		COM_netscape=no \
		COM_acroread=no \
		$(usev !latex COM_latex=no) \
		$(usev !emacs EMACS=no)
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

	use emacs && elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	dodoc ANNOUNCE AUTHORS ChangeLog FAQ NEWS README* THANKS TODO
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
