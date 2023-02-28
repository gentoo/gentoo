# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_AUTOMAKE=none
WANT_LIBTOOL=none

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/gwsw/less"
	inherit git-r3
fi

inherit autotools

# Releases are usually first a beta then promoted to stable if no
# issues were found. Upstream explicitly ask "to not generally distribute"
# the beta versions. It's okay to keyword beta versions if they fix
# a serious bug, but otherwise try to avoid it.

MY_PV=${PV/_beta/-beta}
MY_P=${PN}-${MY_PV}
DESCRIPTION="Excellent text file viewer"
HOMEPAGE="http://www.greenwoodsoftware.com/less/"
[[ ${PV} != 9999 ]] && SRC_URI="http://www.greenwoodsoftware.com/less/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P/?beta}

LICENSE="|| ( GPL-3 BSD-2 )"
SLOT="0"
if [[ ${PV} != 9999 && ${PV} != *_beta* ]] ; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi
IUSE="pcre"
# As of 623_beta, lesstest is not included in dist tarballs
# https://github.com/gwsw/less/issues/344
RESTRICT="test"

DEPEND="
	>=app-misc/editor-wrapper-3
	>=sys-libs/ncurses-5.2:=
	pcre? ( dev-libs/libpcre2 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# Per upstream README to prepare live build
	[[ ${PV} == 9999 ]] && emake -f Makefile.aut distfiles
	# Upstream uses unpatched autoconf-2.69, which breaks with clang-16.
	# https://bugs.gentoo.org/870412
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-regex=$(usex pcre pcre2 posix)
		--with-editor="${EPREFIX}"/usr/libexec/editor
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	emake check VERBOSE=1
}

src_install() {
	default

	newbin "${FILESDIR}"/lesspipe-r1.sh lesspipe
	newenvd "${FILESDIR}"/less.envd 70less
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-483-r1" ; then
		elog "The lesspipe.sh symlink has been dropped.  If you are still setting"
		elog "LESSOPEN to that, you will need to update it to '|lesspipe %s'."
		elog "Colorization support has been dropped.  If you want that, check out"
		elog "the new app-text/lesspipe package."
	fi
}
