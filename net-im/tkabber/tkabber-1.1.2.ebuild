# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A jabber client written in Tcl/Tk"
HOMEPAGE="http://tkabber.jabber.ru/"
SRC_URI="
	http://files.jabber.ru/tkabber/${P}.tar.xz
	plugins? ( http://files.jabber.ru/tkabber/tkabber-plugins-${PV}.tar.xz )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="plugins ssl"

DEPEND="
	>=dev-lang/tcl-8.4.9:0=
	>=dev-lang/tk-8.4.9:0=
	>=dev-tcltk/tcllib-1.3
	>=dev-tcltk/bwidget-1.3
	>=dev-tcltk/tkimg-1.2
	>=dev-tcltk/tktray-1.3
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
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr" \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}"

	dodoc AUTHORS ChangeLog INSTALL README

	if use plugins; then
		cd "${WORKDIR}/tkabber-plugins-${PV}" || die "Couldn't enter tkabber-plugins dir!"
		emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr" \
			DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	fi
}
