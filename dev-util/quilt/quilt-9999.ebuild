# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://git.savannah.gnu.org/git/quilt.git"

[[ ${PV} == 9999 ]] && inherit git-r3

inherit autotools bash-completion-r1 elisp-common

DESCRIPTION="quilt patch manager"
HOMEPAGE="https://savannah.nongnu.org/projects/quilt"
[[ ${PV} == 9999 ]] || SRC_URI="https://savannah.nongnu.org/download/quilt/${P}.tar.gz"

LICENSE="GPL-2 GPL-1+"  # any GPL version for quilt.el
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-solaris"
IUSE="emacs graphviz"

RDEPEND="dev-util/diffstat
	mail-mta/sendmail
	sys-apps/ed
	elibc_Darwin? ( app-misc/getopt )
	elibc_SunOS? ( app-misc/getopt )
	>=sys-apps/coreutils-8.32-r1
	graphviz? ( media-gfx/graphviz )
	app-arch/zstd:=
"

PATCHES=( "${FILESDIR}"/${PN}-el-0.45.4-header-window.patch )

src_prepare() {
	# Add support for USE=graphviz
	use graphviz || PATCHES+=( "${FILESDIR}"/${PN}-0.66-no-graphviz.patch )
	default

	# remove failing test, because it fails on root-build
	rm -rf test/delete.test
}

src_configure() {
	local myconf=()
	[[ ${CHOST} == *-darwin* || ${CHOST} == *-solaris* ]] \
		&& myconf+=( "--with-getopt=${EPREFIX}/usr/bin/getopt-long" )
	econf "${myconf[@]}"
	eautoreconf
	default
}

src_compile() {
	default
	use emacs && elisp-compile lib/quilt.el
}

src_install() {
	emake BUILD_ROOT="${D}" install

	rm -rf "${ED}"/usr/share/doc/${PN}
	dodoc AUTHORS COPYING NEWS TODO "doc/README" "doc/README.MAIL" "doc/quilt.pdf"

	# Remove misplaced Emacs mode
	rm -rf "${ED}"/usr/share/emacs || die

	if use emacs; then
		elisp-install ${PN} lib/quilt.{el,elc}
		elisp-site-file-install "${FILESDIR}"/50${PN}-gentoo.el
		dodoc doc/README.EMACS
	fi

	rm -rf "${ED}"/etc/bash_completion.d
	newbashcomp bash_completion ${PN}

	# Remove the compat symlinks
	rm -rf "${ED}"/usr/share/quilt/compat
}
