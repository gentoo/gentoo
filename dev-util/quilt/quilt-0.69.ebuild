# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit bash-completion-r1 elisp-common

DESCRIPTION="quilt patch manager"
HOMEPAGE="https://savannah.nongnu.org/projects/quilt"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2 GPL-1+"  # any GPL version for quilt.el
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="emacs graphviz"
# unresolved test failures
RESTRICT="test"

RDEPEND="sys-apps/ed
	dev-util/diffstat
	graphviz? ( media-gfx/graphviz )
	elibc_Darwin? ( app-misc/getopt )
	elibc_SunOS? ( app-misc/getopt )
	sys-apps/coreutils
	app-arch/zstd:="

PATCHES=( "${FILESDIR}"/${PN}-el-0.45.4-header-window.patch )

pkg_setup() {
	use graphviz && return 0
	echo
	elog "If you intend to use the folding functionality (graphical illustration of the"
	elog "patch stack) then you'll need to remerge this package with USE=graphviz."
	echo
}

src_prepare() {
	# Add support for USE=graphviz
	use graphviz || PATCHES+=( "${FILESDIR}"/${PN}-0.66-no-graphviz.patch )
	default
}

src_configure() {
	local myconf=()
	[[ ${CHOST} == *-darwin* || ${CHOST} == *-solaris* ]] \
		&& myconf+=( "--with-getopt=${EPREFIX}/usr/bin/getopt-long" )
	econf "${myconf[@]}"
}

src_compile() {
	default
	use emacs && elisp-compile lib/quilt.el
}

src_install() {
	emake BUILD_ROOT="${D}" install

	rm -rf "${ED}"/usr/share/doc/${P}
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
