# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit bash-completion-r1

DESCRIPTION="quilt patch manager"
HOMEPAGE="https://savannah.nongnu.org/projects/quilt"
SRC_URI="https://savannah.nongnu.org/download/quilt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="emacs graphviz"
# unresolved test failures
RESTRICT="test"

RDEPEND="sys-apps/ed
	dev-util/diffstat
	graphviz? ( media-gfx/graphviz )
	elibc_Darwin? ( app-misc/getopt )
	elibc_SunOS? ( app-misc/getopt )
	>=sys-apps/coreutils-8.32-r1"

PDEPEND="emacs? ( app-emacs/quilt-el )"

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
	[[ ${CHOST} == *-darwin* || ${CHOST} == *-solaris* ]] && \
		myconf="${myconf} --with-getopt=${EPREFIX}/usr/bin/getopt-long"
	econf ${myconf}
}

src_install() {
	emake BUILD_ROOT="${D}" install

	rm -rf "${ED}"/usr/share/doc/${P}
	dodoc AUTHORS TODO "doc/README" "doc/README.MAIL" "doc/quilt.pdf"

	rm -rf "${ED}"/etc/bash_completion.d
	newbashcomp bash_completion ${PN}

	# Remove the compat symlinks
	rm -rf "${ED}"/usr/share/quilt/compat

	# Remove Emacs mode; newer version is in app-emacs/quilt-el, bug 247500
	rm -rf "${ED}"/usr/share/emacs
}
