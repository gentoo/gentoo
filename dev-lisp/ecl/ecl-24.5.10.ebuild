# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

DESCRIPTION="ECL is an embeddable Common Lisp implementation"
HOMEPAGE="https://common-lisp.net/project/ecl/"
SRC_URI="https://common-lisp.net/project/ecl/static/files/release/${P}.tgz"

LICENSE="BSD-2 LGPL-2.1+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux"
IUSE="cxx debug emacs gengc precisegc cpu_flags_x86_sse +threads +unicode X"
# test phase only works if ecl already installed #516876
RESTRICT="test"

RDEPEND="dev-libs/gmp:0=
		dev-libs/libffi:=
		dev-libs/libatomic_ops
		>=dev-libs/boehm-gc-7.1[threads?]
		>=dev-lisp/asdf-2.33-r3:="
DEPEND="${RDEPEND}
		app-text/texi2html
		emacs? ( >=app-editors/emacs-23.1:* >=app-eselect/eselect-emacs-1.12 )"

DOCS=( README.md CHANGELOG )

PATCHES=(
	"${FILESDIR}/${PN}-16.1.3-headers-gentoo.patch"
	"${FILESDIR}/${PN}-16.1.3-build.patch"
	"${FILESDIR}/${PN}-21.2.1-donotcompressinfo.patch"
)

src_prepare() {
	default
	cp "${EPREFIX}"/usr/share/common-lisp/source/asdf/build/asdf.lisp contrib/asdf/ || die
}

src_configure() {
	econf \
		--enable-gmp=system \
		--enable-boehm=system \
		--with-dffi \
		--enable-libatomic=system \
		--with-defsystem \
		$(use_with cxx) \
		$(use_enable gengc) \
		$(use_enable precisegc) \
		$(use_with debug debug-cflags) \
		$(use_with cpu_flags_x86_sse sse) \
		$(use_enable threads) \
		$(use_enable unicode) \
		$(use_with X x)
}

src_compile() {
	if use emacs; then
		local ETAGS=$(eselect --brief etags list | sed -ne '/emacs/{p;q}')
		[[ -n ${ETAGS} ]] || die "No etags implementation found"
		pushd build > /dev/null || die
		emake ETAGS=${ETAGS} TAGS
		popd > /dev/null || die
	else
		touch build/TAGS
	fi

	## for /proc/self/clear_refs (see #867052)
	addpredict /proc

	emake
}

src_install() {
	default

	readme.gentoo_create_doc
	pushd build/doc > /dev/null || die
	newman ecl.man ecl.1
	newman ecl-config.man ecl-config.1
	popd > /dev/null || die
}

pkg_postinst() {
	readme.gentoo_print_elog
}
