# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix common-lisp-3

DESCRIPTION="ASDF is Another System Definition Facility for Common Lisp"
HOMEPAGE="https://asdf.common-lisp.dev/"
SRC_URI="https://asdf.common-lisp.dev/archives/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PVR}"
KEYWORDS="~alpha amd64 ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( virtual/texi2dvi )
	test? ( virtual/commonlisp )"
PDEPEND="virtual/commonlisp
	~dev-lisp/uiop-${PV}"

PATCHES=(
	# bug 841335, drop on next version bump
	"${FILESDIR}"/${PN}-3.3.5-test-utilities.patch
)

install_docs() {
	(
		cd doc || die
		dodoc *.{html,css,ico,png} ${PN}.pdf
		doinfo ${PN}.info

		# texinfo-7 renamed the dir from asdf to asdf_html #883439
		if [[ -d asdf_html ]]; then
			dodoc -r asdf_html
		else
			docinto asdf_html
			dodoc -r asdf/.
		fi
	)
}

src_compile() {
	emake

	use doc && emake -C doc
}

src_test() {
	common-lisp-export-impl-args "$(common-lisp-find-lisp-impl)"

	rm test/test-program.script || die

	# sbcl in common-lisp.eclass has --non-interactive in the binary name
	# which seems to break this?
	test/run-tests.sh ${CL_BINARY/--non-interactive/} || die
}

src_install() {
	insinto "${CLSOURCEROOT}/${PN}"
	doins -r build version.lisp-expr

	dodoc README.md TODO
	use doc && install_docs

	insinto /etc/common-lisp
	cd "${T}" || die
	cp "${FILESDIR}"/gentoo-init.lisp "${FILESDIR}"/source-registry.conf . || die
	eprefixify gentoo-init.lisp source-registry.conf
	doins gentoo-init.lisp source-registry.conf
}
