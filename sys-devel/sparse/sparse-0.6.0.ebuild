# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib toolchain-funcs

DESCRIPTION="C semantic parser"
HOMEPAGE="https://sparse.wiki.kernel.org/index.php/Main_Page"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/devel/${PN}/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://www.kernel.org/pub/software/devel/${PN}/dist/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="gtk llvm test xml"
RESTRICT="!test? ( test )"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	llvm? ( >=sys-devel/llvm-3.0 )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )
	xml? ( virtual/pkgconfig )"

_emake() {
	# Makefile does not allow for an easy override of flags.
	# Collect them here and override default phases.
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CFLAGS}" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		\
		HAVE_GTK=$(usex gtk) \
		HAVE_LLVM=$(usex llvm) \
		HAVE_LIBXML=$(usex xml) \
		\
		V=1 \
		PREFIX="${EPREFIX}/usr" \
		\
		"$@"
}

src_compile() {
	_emake
}

src_test() {
	_emake check
}

src_install() {
	_emake DESTDIR="${D}" install

	dodoc FAQ README
}
