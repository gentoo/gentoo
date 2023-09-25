# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Releases are usually first a beta then promoted to stable if no
# issues were found. Upstream explicitly ask "to not generally distribute"
# the beta versions. It's okay to keyword beta versions if they fix
# a serious bug, but otherwise try to avoid it.

WANT_AUTOMAKE=none
WANT_LIBTOOL=none
inherit autotools flag-o-matic optfeature toolchain-funcs

DESCRIPTION="Excellent text file viewer"
HOMEPAGE="https://www.greenwoodsoftware.com/less/"

MY_PV=${PV/_beta/-beta}
MY_P=${PN}-${MY_PV}

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/gwsw/less"
	inherit git-r3
else
	SRC_URI="https://www.greenwoodsoftware.com/less/${MY_P}.tar.gz"

	if [[ ${PV} != *_beta* ]] ; then
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	fi
fi

S="${WORKDIR}"/${MY_P/?beta}

LICENSE="|| ( GPL-3 BSD-2 )"
SLOT="0"
IUSE="pcre test"
# chinese1, utf8-2
RESTRICT="test !test? ( test )"

DEPEND="
	>=app-misc/editor-wrapper-3
	>=sys-libs/ncurses-5.2:=
	pcre? ( dev-libs/libpcre2 )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${PN}-643-lesstest-pkg-config.patch
)

src_prepare() {
	default
	# Per upstream README to prepare live build
	[[ ${PV} == 9999 ]] && emake -f Makefile.aut distfiles
	# Upstream uses unpatched autoconf-2.69, which breaks with clang-16.
	# https://bugs.gentoo.org/870412
	eautoreconf
}

src_configure() {
	append-lfs-flags # bug #896316

	local myeconfargs=(
		--with-regex=$(usex pcre pcre2 posix)
		--with-editor="${EPREFIX}"/usr/libexec/editor
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	emake check VERBOSE=1 CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	default

	newbin "${FILESDIR}"/lesspipe-r2.sh lesspipe
	newenvd "${FILESDIR}"/less.envd 70less
}

pkg_preinst() {
	optfeature "Colorized output supprt" dev-python/pygments

	if has_version "<${CATEGORY}/${PN}-483-r1" ; then
		elog "The lesspipe.sh symlink has been dropped.  If you are still setting"
		elog "LESSOPEN to that, you will need to update it to '|lesspipe %s'."
	fi

	if has_version "<${CATEGORY}/${PN}-643" ; then
		elog "less now colorizes by default. To disable this, set LESSCOLOR=no."
	fi
}
