# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/plowshare/plowshare-1.2.0.ebuild,v 1.1 2015/02/03 14:39:22 voyageur Exp $

EAPI=5

inherit bash-completion-r1

DESCRIPTION="Command-line downloader and uploader for file-sharing websites"
HOMEPAGE="http://code.google.com/p/plowshare/"
# Fetched from http://${PN}.googlecode.com/archive/v${PV}.tar.gz
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="bash-completion +javascript view-captcha"

RDEPEND="
	>=app-shells/bash-4
	|| ( app-text/recode ( dev-lang/perl dev-perl/HTML-Parser ) )
	|| ( media-gfx/imagemagick[tiff] media-gfx/graphicsmagick[imagemagick,tiff] )
	net-misc/curl
	sys-apps/util-linux
	javascript? ( || ( dev-lang/spidermonkey:0 dev-java/rhino ) )
	view-captcha? ( || ( media-gfx/aview media-libs/libcaca ) )"
DEPEND=""

# NOTES:
# javascript dep should be any javascript interpreter using /usr/bin/js

# Modules using detect_javascript
JS_MODULES="flashx letitbit nowdownload_co oboom rapidgator yourvideohost zalaa zippyshare"

src_prepare() {
	if ! use javascript; then
		for module in ${JS_MODULES}; do
			sed -i -e "s:^${module}.*::" src/modules/config || die "${module} sed failed"
			rm src/modules/${module}.sh || die "${module} rm failed"
		done
	fi

	# Fix doc install path
	sed -i -e "/^DOCDIR/s|plowshare4|${P}|" Makefile || die "sed failed"

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
	if ! use javascript; then
		ewarn "Without javascript you will not be able to use:"
		ewarn " ${JS_MODULES}"
	fi
}
