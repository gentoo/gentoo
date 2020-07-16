# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="SLIME, the Superior Lisp Interaction Mode (Extended)"
HOMEPAGE="http://common-lisp.net/project/slime/"
SRC_URI="https://github.com/slime/slime/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 xref? ( xref.lisp )"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
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

PATCHES=(
	# Should be fixed in >=app-emacs/slime-2.20
	"${FILESDIR}/${PN}-2.20-fix-doc-build.patch"
)

src_prepare() {
	default
	# Remove xref.lisp (which is non-free) unless USE flag is set
	use xref || rm -f xref.lisp
}

src_compile() {
	elisp-compile *.el
	BYTECOMPFLAGS="${BYTECOMPFLAGS} -L contrib -l slime" \
		elisp-compile contrib/*.el lib/*.el

	emake -C doc slime.info
	if use doc ; then
		VARTEXFONTS="${T}"/fonts \
			emake -C doc all
	fi
}

src_install() {
	## install core
	elisp-install ${PN} *.{el,elc,lisp}

	## install contribs
	elisp-install ${PN}/contrib/ contrib/*.{el,elc,lisp,scm,goo}

	## install lib
	elisp-install ${PN}/lib/ lib/*.{el,elc}

	## install swank
	elisp-install ${PN}/swank/ swank/*.lisp

	elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	## install docs
	dodoc README.md CONTRIBUTING.md NEWS PROBLEMS
	newdoc contrib/README.md README-contrib.md
	doinfo doc/slime.info
	use doc && dodoc doc/*.pdf
}
