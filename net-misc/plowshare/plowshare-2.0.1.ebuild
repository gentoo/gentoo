# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit bash-completion-r1

DESCRIPTION="Command-line downloader and uploader for file-sharing websites"
HOMEPAGE="http://code.google.com/p/plowshare/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="bash-completion +javascript +modules view-captcha"

MOD_PV="2ededde1f34e78dcbacf02e900a2ce8cad2e148d"
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz
	modules? ( http://dev.gentoo.org/~voyageur/distfiles/${PN}-modules-${MOD_PV}.tar.gz )"

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

src_unpack() {
	default
	if use modules; then
		rm -r "${S}"/src/modules
		mv ${PN}-modules-${MOD_PV} "${S}"/src/modules
	fi
}

src_prepare() {
	if use modules && ! use javascript; then
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
	if use modules; then
		elog "System-wide modules can break between releases, install per-user versions"
		elog "in ~/.config/plowshare/modules if needed"
		if ! use javascript; then
			ewarn "Without javascript you will not be able to use:"
			ewarn " ${JS_MODULES}"
		fi
	else
		elog "plowshare is not delivered with modules by default anymore"
		elog "Per-user modules should be installed as described at:"
		elog "https://code.google.com/p/plowshare/wiki/Readme#Installation_of_modules"
		elog "USE=modules will install a system-wide set occasionally updated"
	fi
}
