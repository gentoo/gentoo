# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/lash/lash-0.5.4-r1.ebuild,v 1.18 2013/02/25 08:04:11 ssuominen Exp $

EAPI=4

PYTHON_DEPEND="python? 2:2.6"
inherit autotools eutils python

DESCRIPTION="LASH Audio Session Handler"
HOMEPAGE="http://www.nongnu.org/lash/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="alsa debug gtk python static-libs" # doc

RDEPEND="dev-libs/libxml2
	media-sound/jack-audio-connection-kit
	alsa? ( media-libs/alsa-lib )
	gtk? ( x11-libs/gtk+:2 )
	|| ( sys-libs/readline dev-libs/libedit )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	python? ( >=dev-lang/swig-1.3.40 )"
# doc? ( >=app-text/texi2html-5 )

DOCS="AUTHORS ChangeLog NEWS README TODO"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	sed -i \
		-e '/texi2html/s:-number:&-sections:' \
		docs/Makefile.am || die #422045

	epatch \
		"${FILESDIR}"/${P}-glibc2.8.patch \
		"${FILESDIR}"/${P}-swig_version_comparison.patch \
		"${FILESDIR}"/${P}-gcc47.patch

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	# 'no' could be '$(usex doc)' but we use the pregenerated lash-manual.html
	export ac_cv_prog_lash_texi2html=no #422045

	# --enable-pylash would disable it
	local myconf
	use python || myconf='--disable-pylash'

	econf \
		$(use_enable static-libs static) \
		$(use_enable alsa alsa-midi) \
		$(use_enable gtk gtk2) \
		$(use_enable debug) \
		${myconf}
}

src_install() {
	default
	dohtml docs/lash-manual-html-*/lash-manual.html
	prune_libtool_files --all # --all for _lash.la in python directory
}

pkg_postinst() {
	use python && python_mod_optimize lash.py
}

pkg_postrm() {
	use python && python_mod_cleanup lash.py
}
