# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: Only SBCL (dev-lisp/sbcl) is tested for now, but probably
#   more CL implementations can be added as alternative dependencies.
#   With ClozureCL (dev-lisp/clozurecl) ACL2 fails to build,
#   this might need in-depth investigation...

EAPI=8

inherit elisp-common

DESCRIPTION="Industrial strength theorem prover, logic and programming language"
HOMEPAGE="https://www.cs.utexas.edu/users/moore/acl2/
	https://github.com/acl2/acl2/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	COMMIT=6ba68b5c8d645ca45185abc4a24ce46e5ae029c5
	SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc emacs"
REQUIRED_USE="emacs? ( doc )"

# SBCL <= 2.4.1 is required, see: https://github.com/acl2/acl2/issues/1580
RDEPEND="
	<=dev-lisp/sbcl-2.4.1:=
	emacs? ( >=app-editors/emacs-25:* )
"
BDEPEND="
	${RDEPEND}
	doc? ( dev-lang/perl )
"

DOCS=( books/README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	find . -type f -name "*.bak" -delete || die
	find . -type f -name "*.orig" -delete || die
	rm books/workshops/2003/schmaltz-al-sammane-et-al/support/acl2link || die

	sed -e "s|\"git\" '(\"rev-parse\" \"HEAD\")|\"echo\" '(\"${COMMIT}\")|" \
		-i acl2-init.lisp || die

	default
}

src_compile() {
	emake LISP="sbcl --no-sysinit --no-userinit --disable-debugger"

	if use emacs ; then
		local elisp_dir
		for elisp_dir in books/emacs books/interface/emacs ; do
			BYTECOMPFLAGS="-L ${S}/${elisp_dir}"        \
				elisp-compile "${S}/${elisp_dir}"/*.el
		done
	fi

	if use doc ; then
		emake ACL2="${S}/saved_acl2" basic DOC
	fi
}

src_install() {
	local saved_name=saved_acl2

	sed "s|${S}|/usr/share/acl2|g" -i "${saved_name}" || die
	sed "5iexport ACL2_SYSTEM_BOOKS=/usr/share/acl2/books/"    \
		-i "${saved_name}" || die

	exeinto /usr/share/acl2
	doexe "${saved_name}"
	insinto /usr/share/acl2
	doins "${saved_name}.core"
	dosym -r "/usr/share/acl2/${saved_name}" /usr/bin/acl2

	if use emacs ; then
		doins TAGS
		elisp-install "${PN}" books/emacs/*.el{,c} books/interface/emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use doc ; then
		doins -r books

		HTML_DOCS=( doc/HTML/. )
		einstalldocs

		# Some binaries in "books". Not needed since the sources are there.
		find "${ED}/usr/share/acl2/books" -type f -name "*.elf64" -delete || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
