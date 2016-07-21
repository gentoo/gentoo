# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bash-completion-r1

DESCRIPTION="Command-line downloader and uploader for file-sharing websites"
HOMEPAGE="https://github.com/mcrapet/plowshare"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="bash-completion +javascript view-captcha"

SRC_URI="https://github.com/mcrapet/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND="
	>=app-shells/bash-4
	|| ( app-text/recode ( dev-lang/perl dev-perl/HTML-Parser ) )
	dev-vcs/git
	|| ( media-gfx/imagemagick[tiff] media-gfx/graphicsmagick[imagemagick,tiff] )
	net-misc/curl
	sys-apps/util-linux
	javascript? ( || ( dev-lang/spidermonkey:0 dev-java/rhino ) )
	view-captcha? ( || ( media-gfx/aview media-libs/libcaca ) )"
DEPEND=""

# NOTES:
# javascript dep should be any javascript interpreter using /usr/bin/js

src_prepare() {
	# Fix doc install path
	sed -i -e "/^DOCDIR/s|plowshare|${PF}|" Makefile || die "sed failed"

	if ! use bash-completion
	then
		sed -i -e \ "/^install:/s/install_bash_completion//" \
			Makefile || die "sed failed"
	fi
}

src_compile() {
	# There is a Makefile but it's not compiling anything, let's not try.
	:
}

src_test() {
	# Disable tests because all of them need a working Internet connection.
	:
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" \
		PLOWSHARE_FORCE_VERSION="${PV}" install
}

pkg_postinst() {
	elog "plowshare is not delivered with modules by default anymore"
	elog "Per-user modules can be installed/updated with the plowmod command"
	if ! use javascript; then
		ewarn "Without javascript you will not be able to use modules"
		ewarn "requering a Javascript shell (/usr/bin/js)"
	fi
}
