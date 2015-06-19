# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/edna/edna-0.6.ebuild,v 1.14 2015/04/13 08:21:49 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib user python-r1

DESCRIPTION="Greg Stein's python streaming audio server for desktop or LAN use"
HOMEPAGE="http://edna.sourceforge.net/"
SRC_URI="mirror://sourceforge/edna/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="flac ogg"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	flac? ( media-libs/mutagen[${PYTHON_USEDEP}] )
	ogg? ( dev-python/pyogg[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}/${P}"-SystemExit.patch \
		"${FILESDIR}/${P}"-flac.patch \
		"${FILESDIR}/${P}"-daemon.patch \
		"${FILESDIR}/${P}"-syslog.patch
}

src_install() {
	newinitd "${FILESDIR}"/edna.gentoo edna

	python_foreach_impl python_newscript edna.py edna

	python_scriptinto /usr/$(get_libdir)/edna
	python_foreach_impl python_domodule ezt.py MP3Info.py

	python_foreach_impl python_optimize

	insinto /usr/$(get_libdir)/edna
	doins -r templates resources

	insinto /etc/edna
	doins edna.conf

	dosym /usr/$(get_libdir)/edna/resources /etc/edna/resources
	dosym /usr/$(get_libdir)/edna/templates /etc/edna/templates

	dodoc README ChangeLog
	dohtml -r www/*
}

pkg_postinst() {
	enewgroup edna
	enewuser edna -1 -1 -1 edna

	elog "Edit edna.conf to taste before starting (multiple source"
	elog "directories are allowed).  Test edna from a shell prompt"
	elog "until you have it configured properly, then add edna to"
	elog "the default runlevel when you're ready.  Add the USE flag"
	elog "vorbis if you want edna to serve ogg files."
	elog "See edna.conf and the html docs for more info, and set"
	elog "PYTHONPATH=/usr/lib/edna to run from a shell prompt."
}
