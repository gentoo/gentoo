# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="git://git.sv.gnu.org/quilt.git"

[[ ${PV} == 9999 ]] && inherit git-r3

inherit bash-completion-r1

DESCRIPTION="quilt patch manager"
HOMEPAGE="https://savannah.nongnu.org/projects/quilt"
[[ ${PV} == 9999 ]] || SRC_URI="https://savannah.nongnu.org/download/quilt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris"
IUSE="graphviz elibc_Darwin elibc_SunOS"

RDEPEND="
	dev-util/diffstat
	mail-mta/sendmail
	sys-apps/ed
	elibc_Darwin? ( app-misc/getopt )
	elibc_SunOS? ( app-misc/getopt )
	>=sys-apps/coreutils-8.5
	graphviz? ( media-gfx/graphviz )
"

src_prepare() {

	default

	# Add support for USE=graphviz
	use graphviz || eapply "${FILESDIR}/${PN}-0.66-no-graphviz.patch"

	# remove failing test, because it fails on root-build
	rm -rf test/delete.test
}

src_configure() {
	local myconf=""
	[[ ${CHOST} == *-darwin* || ${CHOST} == *-solaris* ]] && \
		myconf="${myconf} --with-getopt=${EPREFIX}/usr/bin/getopt-long"
	econf ${myconf}
}

src_install() {
	emake BUILD_ROOT="${D}" install

	rm -rf "${ED}"/etc/bash_completion.d
	newbashcomp bash_completion ${PN}

	rm -rf "${ED}"usr/share/doc/${PN}
	dodoc AUTHORS TODO "doc/README" "doc/README.MAIL" "doc/quilt.pdf"

	# Remove the compat symlinks
	rm -rf "${ED}"/usr/share/quilt/compat

	# Remove Emacs mode; newer version is in app-emacs/quilt-el, bug 247500
	rm -rf "${ED}"/usr/share/emacs
}

pkg_postinst() {
	if ! has_version app-emacs/quilt-el ; then
		elog "If you plan to use quilt with emacs consider installing \"app-emacs/quilt-el\""
	fi
}
