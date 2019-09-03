# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic multilib

DESCRIPTION="Amateur Radio VHF Contest Logbook"
HOMEPAGE="http://tucnak.nagano.cz"
SRC_URI="http://tucnak.nagano.cz/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa fftw gpm hamlib suid"

RDEPEND="dev-libs/glib:2
	dev-libs/libzia
	media-libs/libsndfile
	>=media-libs/libsdl-1.2
	alsa? ( media-libs/alsa-lib )
	fftw? ( sci-libs/fftw:3.0 )
	gpm? ( sys-libs/gpm )
	hamlib? ( media-libs/hamlib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eapply_user
	# fix destop file
	sed -i -e "s/HamRadio/HamRadio;/" share/applications/tucnak.desktop || die
	# fix doc install path
	sed -i -e "s/docsdir/# docsdir/" \
		-e "s/docs_DATA =/# docs_DATA/" \
		-e "s/EXTRA_DIST =/# EXTRA_DIST =/" Makefile.am doc/Makefile.am || die
	eautoreconf
}

src_configure() {
	append-ldflags -L/usr/$(get_libdir)/hamlib
	econf $(use_with alsa) \
		$(use_with gpm) $(use_with hamlib) \
		$(use_with fftw fftw3)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog doc/NAVOD.pdf
	if use suid ; then
		fperms 4711 /usr/bin/soundwrapper
	fi
}

pkg_postinst() {
	elog "In order to use sound with tucnak add yourself to the 'audio' group"
	elog "and to key your rig via the parport add yourself to the 'lp' group"
	elog ""
	elog "tucnak can be used with the following additional packages:"
	elog "	   media-radio/cwdaemon  : Morse output via code cwdaemon"
	elog "                             (No need to recompile)"
	if use suid ; then
		ewarn "You have choosen to install the little helper program 'soundwrapper'"
		ewarn "setuid by setting USE=suid. That helper is only needed if you"
		ewarn "want to use morse sidetone output via the PC speaker."
		ewarn ""
		ewarn "While the helper should be safe by design be aware that setting"
		ewarn "any program setuid is a security risk."
	fi
}
