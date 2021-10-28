# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common flag-o-matic

MY_PN=Singular
MY_PV=$(ver_rs 3 '')
# Consistency is different...
MY_DIR2=$(ver_cut 1-3 ${PV})
MY_DIR=$(ver_rs 1- '-' ${MY_DIR2})

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="https://www.singular.uni-kl.de/ https://github.com/Singular/Sources"
SRC_URI="ftp://jim.mathematik.uni-kl.de/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_DIR2}"

LICENSE="BSD GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE="emacs examples julia polymake +readline static-libs"

RDEPEND="
	dev-lang/perl
	dev-libs/gmp:0
	dev-libs/ntl:=
	sci-libs/cddlib
	sci-mathematics/flint
	emacs? ( >=app-editors/emacs-23.1:* )
	julia? ( dev-lang/julia )
	polymake? ( sci-mathematics/polymake )
	readline? ( sys-libs/readline )
"
DEPEND="${RDEPEND}"

SITEFILE=60${PN}-gentoo.el

PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-doc_install-v2.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Needed to avoid segfaults in the test suite until
	#
	#   https://github.com/Singular/Singular/issues/1105
	#
	# makes its way into a release.
	append-cxxflags $(test-flags-CXX -fno-delete-null-pointer-checks)

	local myconf=(
		--disable-debug
		--disable-doc
		--disable-optimizationflags
		--disable-pyobject-module
		--disable-python
		--disable-python-module
		--disable-python_module
		--enable-factory
		--enable-gfanlib
		--enable-libfac
		--with-flint
		--with-gmp
		--with-libparse
		--with-ntl
		--without-python
		--without-pythonmodule
		$(use_enable emacs)
		$(use_enable julia)
		$(use_enable polymake polymake-module)
		$(use_enable static-libs static)
		$(use_with readline)
	)
	econf "${myconf[@]}"
}

src_compile() {
	default

	if use emacs; then
		pushd "${S}"/emacs
		elisp-compile *.el || die "elisp-compile failed"
		popd
	fi
}

src_install() {
	# Do not compress singular's info file (singular.hlp)
	# some consumer of that file do not know how to deal with compression
	docompress -x /usr/share/info

	default

	dosym Singular /usr/bin/"${PN}"

	# purge .la file
	find "${ED}" -name '*.la' -delete || die
}

src_test() {
	# SINGULAR_PROCS_DIR need to be set to "" otherwise plugins from
	# an already installed version of singular may be used and cause segfault
	# See https://github.com/Singular/Sources/issues/980
	SINGULAR_PROCS_DIR="" emake check
}

pkg_postinst() {
	einfo "Additional functionality can be enabled by installing"
	einfo "sci-mathematics/4ti2"

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
