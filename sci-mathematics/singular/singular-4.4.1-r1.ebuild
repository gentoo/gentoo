# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common

MY_PN=Singular
MY_PV=$(ver_rs 3 '')
# Consistency is different...
MY_DIR2=$(ver_cut 1-3 ${PV})
MY_DIR=$(ver_rs 1- '-' ${MY_DIR2})

DESCRIPTION="Computer algebra system for polynomial computations"
HOMEPAGE="https://www.singular.uni-kl.de/ https://github.com/Singular/Singular"
SRC_URI="https://www.singular.uni-kl.de/ftp/pub/Math/${MY_PN}/SOURCES/${MY_DIR}/${PN}-${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_DIR2}"

# Most files say "version 2 or version 3 of the License," which is not
# quite GPL-2+, and is why we have listed GPL-2 below. But AFAIK there
# are no GPL-2-only files.
LICENSE="BSD GPL-2 GPL-2+ GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86 ~x86-linux"
IUSE="emacs examples polymake +readline"

# The interactive help uses "info" from sys-apps/texinfo.
RDEPEND="
	dev-lang/perl
	dev-libs/gmp:0=
	dev-libs/ntl:=
	sci-libs/cddlib
	sci-mathematics/flint:=
	sys-apps/texinfo
	emacs? ( app-editors/emacs:* )
	polymake? ( sci-mathematics/polymake )
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"

SITEFILE=60${PN}-gentoo.el

PATCHES=(
	"${FILESDIR}/flint-3.3.0-compatibility.patch"
)

src_configure() {
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
		$(use_enable polymake polymake-module)
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

	find "${ED}" -type f -name '*.la' -delete || die
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
