# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://git.sv.gnu.org/quilt.git"

[[ ${PV} == 9999 ]] && inherit git-2

inherit bash-completion-r1 eutils

DESCRIPTION="quilt patch manager"
HOMEPAGE="https://savannah.nongnu.org/projects/quilt"
[[ ${PV} == 9999 ]] || SRC_URI="https://savannah.nongnu.org/download/quilt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="graphviz"

RDEPEND="
	dev-util/diffstat
	mail-mta/sendmail
	sys-apps/ed
	>=sys-apps/coreutils-8.5
	graphviz? ( media-gfx/graphviz )
"

src_prepare() {
	# Add support for USE=graphviz
	use graphviz || epatch "${FILESDIR}/${PN}-0.60-no-graphviz.patch"

	# remove failing test, because it fails on root-build
	rm -rf test/delete.test
}

src_install() {
	emake BUILD_ROOT="${ED}" install

	rm -rf "${ED}"/usr/share/doc/${P}
	dodoc AUTHORS TODO quilt.changes doc/README doc/README.MAIL \
		doc/quilt.pdf

	rm -rf "${ED}"/etc/bash_completion.d
	newbashcomp bash_completion ${PN}

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
