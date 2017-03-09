# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

DESCRIPTION="Mozilla extension to provide GPG support in mail clients"
HOMEPAGE="http://www.enigmail.net/"

KEYWORDS="~alpha amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="MPL-2.0 GPL-3"
IUSE=""
SRC_URI="http://www.enigmail.net/download/source/${P}.tar.gz"

RDEPEND="|| (
		( >=app-crypt/gnupg-2.0
			|| (
				app-crypt/pinentry[gtk(-)]
				app-crypt/pinentry[qt4(-)]
				app-crypt/pinentry[qt5(-)]
			)
		)
		=app-crypt/gnupg-1.4*
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	app-arch/zip
	dev-lang/perl
	"

S="${WORKDIR}/${PN}"

src_compile() {
	emake ipc public ui package lang
	emake xpi

}

src_install() {
	insinto /usr/share/${PN}
	doins -r build/dist/{chrome,components,defaults,modules,wrappers,chrome.manifest,install.rdf}
}

pkg_postinst() {
	local peimpl=$(eselect --brief --colour=no pinentry show)
	case "${peimpl}" in
	*gtk*|*qt*) ;;
	*)	ewarn "The pinentry front-end currently selected is not one supported by thunderbird."
		ewarn "You may be prompted for your password in an inaccessible shell!!"
		ewarn "Please use 'eselect pinentry' to select either the gtk or qt front-end"
		;;
	esac
}
