# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Rebuild Emacs packages"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

DEPEND="|| ( sys-apps/util-linux app-misc/getopt )"
RDEPEND="${DEPEND}
	>=app-editors/emacs-23.1:*
	>=app-portage/portage-utils-0.3"

src_prepare() {
	default

	if ! has_version sys-apps/util-linux; then
		# BSD ships a dumb getopt(1), so use getopt-long instead
		sed -i -e '/^GETOPT=/s/getopt/&-long/' emacs-updater || die
	fi

	if [[ -n ${EPREFIX} ]]; then
		sed -i -e "1s:/:${EPREFIX%/}/:" \
			-e "s:^\([[:upper:]]*=\)/:\1${EPREFIX%/}/:" \
			emacs-updater || die
	fi
}

src_install() {
	dosbin emacs-updater
	doman emacs-updater.8
}
