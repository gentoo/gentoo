# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils subversion

DESCRIPTION="Linux Rapidshare downloader"
HOMEPAGE="https://code.google.com/p/slimrat/"
SRC_URI=""
ESVN_REPO_URI="https://${PN}.googlecode.com/svn/trunk/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="X"

DEPEND="
	>=dev-lang/perl-5.10.1[ithreads]
	dev-perl/JSON
	>=dev-perl/WWW-Mechanize-1.52
	virtual/perl-Getopt-Long
	virtual/perl-Term-ANSIColor
	X? (
		dev-perl/gtk2-gladexml
		dev-perl/Spiffy
		x11-misc/xclip
	)
"
# aview: displaying captcha
RDEPEND="${DEPEND}
	media-gfx/aview
	X? ( x11-terms/xterm )
"

src_prepare() {
	esvn_clean
}

src_install() {
	# install binaries

	exeinto "/usr/share/${PN}"

	doexe "src/${PN}"
	dosym "/usr/share/${PN}/${PN}" "${ROOT}usr/bin/${PN}"

	if use X; then
		doexe "src/${PN}-gui"
		dosym "/usr/share/${PN}/${PN}-gui" "/usr/bin/${PN}-gui"
	fi

	# install data
	insinto /etc
	newins "${S}/slimrat.conf" slimrat.conf

	insinto "/usr/share/${PN}"
	doins -r "src/"*.pm "src/plugins/" "src/${PN}.glade"
}
