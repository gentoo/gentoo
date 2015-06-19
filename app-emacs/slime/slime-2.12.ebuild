# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/slime/slime-2.12.ebuild,v 1.1 2015/01/08 04:04:52 gienah Exp $

EAPI=5

[[ ${PV} = *9999* ]] && GIT_ECLASS="git-r3" || GIT_ECLASS=""

inherit common-lisp-3 ${GIT_ECLASS} elisp eutils

DESCRIPTION="SLIME, the Superior Lisp Interaction Mode (Extended)"
HOMEPAGE="http://common-lisp.net/project/slime/"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/slime/slime/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2 xref? ( xref.lisp )"
SLOT="0"
if [[ ${PV} == *9999* ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi
IUSE="doc xref"
RESTRICT=test # tests fail to contact sbcl

RDEPEND="virtual/commonlisp
		dev-lisp/asdf"
DEPEND="${RDEPEND}
		>=sys-apps/texinfo-5.1
		doc? ( virtual/texi2dvi )"

CLPACKAGE=swank
CLSYSTEMS=swank
SITEFILE=70${PN}-gentoo.el

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_REPO_URI="https://github.com/slime/slime.git"
		${GIT_ECLASS}_src_unpack
	fi
	elisp_src_unpack
}

src_prepare() {
	if [[ "${PV}" == "2.11" ]]; then
		epatch "${FILESDIR}"/2.11/dont-load-sbcl-pprint.patch
	fi
	epatch "${FILESDIR}"/2.0_p20130214/gentoo-module-load.patch
	epatch "${FILESDIR}"/2.0_p20110617/gentoo-dont-call-init.patch
	has_version ">=app-editors/emacs-24" && rm -f lib/cl-lib.el

	# extract date of last update from ChangeLog, bug 233270
	SLIME_CHANGELOG_DATE=$(awk '/^[-0-9]+ / { print $1; exit; }' ChangeLog)
	[ -n "${SLIME_CHANGELOG_DATE}" ] || die "cannot determine ChangeLog date"

	# SLIME uses the changelog date to make sure that the emacs side and the CL side
	# are in sync. We hardcode it instead of letting slime determine it at runtime
	# because ChangeLog doesn't get installed to $EMACSDIR
	epatch "${FILESDIR}"/2.11/gentoo-changelog-date.patch

	# When starting slime in emacs, slime looks for ${S}/swank/backend.lisp as
	# /usr/share/common-lisp/source/swank/swank-backend.lisp
	pushd swank || die
	for i in *.lisp
	do
		mv ${i} ../swank-${i}
	done
	popd

	sed -i "/(defvar \*swank-wire-protocol-version\*/s:nil:\"${SLIME_CHANGELOG_DATE}\":" swank.lisp \
		|| die "sed swank.lisp failed"
	sed -i "s:@SLIME-CHANGELOG-DATE@:${SLIME_CHANGELOG_DATE}:" slime.el \
		|| die "sed slime.el failed"
	sed -i "s/@itemx INIT-FUNCTION/@item INIT-FUNCTION/" doc/slime.texi \
		|| die "sed doc/slime.texi failed"

	# Remove xref.lisp (which is non-free) unless USE flag is set
	use xref || rm -f xref.lisp
}

src_compile() {
	elisp-compile *.el || die
	BYTECOMPFLAGS="${BYTECOMPFLAGS} -L contrib -l slime" \
		elisp-compile contrib/*.el lib/*.el || die
	emake -j1 -C doc slime.info || die "Cannot build info docs"

	if use doc; then
		VARTEXFONTS="${T}"/fonts \
			emake -j1 -C doc slime.pdf || die "emake doc failed"
	fi
}

src_install() {
	## install core
	elisp-install ${PN} *.{el,elc} "${FILESDIR}"/swank-loader.lisp \
		|| die "Cannot install SLIME core"
	sed "s:/usr/:${EPREFIX}&:g" "${FILESDIR}"/2.0_p20110617/${SITEFILE} \
		>"${T}"/${SITEFILE} || die "sed failed"
	elisp-site-file-install "${T}"/${SITEFILE} || die
	cp "${FILESDIR}"/2.0_p20110617/swank.asd "${S}"
	# remove upstream swank-loader, since it won't be used
	rm "${S}"/swank-loader.lisp
	common-lisp-install-sources *.lisp
	common-lisp-install-asdf swank.asd

	## install contribs
	elisp-install ${PN}/contrib/ contrib/*.{el,elc,scm,goo} \
		|| die "Cannot install contribs"
	common-lisp-install-sources contrib/*.lisp

	## install lib
	elisp-install ${PN}/lib/ lib/*.{el,elc} \
		|| die "Cannot install libs"

	## install docs
	dodoc README.md ChangeLog CONTRIBUTING.md NEWS PROBLEMS
	newdoc contrib/README.md README-contrib.md
	newdoc contrib/ChangeLog ChangeLog.contrib
	doinfo doc/slime.info
	use doc && dodoc doc/*.pdf
}
