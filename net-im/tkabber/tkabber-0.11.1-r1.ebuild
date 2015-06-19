# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/tkabber/tkabber-0.11.1-r1.ebuild,v 1.5 2015/03/25 16:17:20 jlec Exp $

EAPI=5

DESCRIPTION="A jabber client written in Tcl/Tk"
HOMEPAGE="http://tkabber.jabber.ru/"
SRC_URI="
	http://files.jabber.ru/tkabber/${P}.tar.gz
	plugins? ( http://files.jabber.ru/tkabber/tkabber-plugins-${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="plugins ssl"

DEPEND="
	>=dev-lang/tcl-8.3.3:0=
	>=dev-lang/tk-8.3.3:0=
	>=dev-tcltk/tcllib-1.3
	>=dev-tcltk/bwidget-1.3
	>=dev-tcltk/tkXwin-1.0
	>=dev-tcltk/tkimg-1.2
	>=dev-tcltk/tktray-1.1
	ssl? ( >=dev-tcltk/tls-1.4.1 )
"
RDEPEND="${DEPEND}"

# Disabled because it depends on gpgme 0.3.x
#	crypt? ( >=dev-tcltk/tclgpgme-1.0 )

src_compile() {
	# dont run make, because the Makefile is broken with all=install
	:
}

src_install() {
	emake install DESTDIR="${D}" PREFIX=/usr \
		DOCDIR="/usr/share/doc/${P}"

	dodoc AUTHORS ChangeLog INSTALL README

	if use plugins; then
		cd "${WORKDIR}/tkabber-plugins-${PV}"
		emake install DESTDIR="${D}" PREFIX=/usr \
			DOCDIR="/usr/share/doc/${P}"
	fi
}
