# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Automatic command-line mp3/ogg/flac file tagger and renamer"
HOMEPAGE="http://bgoglin.free.fr/lltag/ https://github.com/bgoglin/lltag"
SRC_URI="https://github.com/bgoglin/lltag/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 ogg readline"

RDEPEND="
	dev-perl/libwww-perl
	flac? ( media-libs/flac )
	mp3? (
		dev-perl/MP3-Tag
		media-sound/mp3info
	)
	ogg? ( media-sound/vorbis-tools )
	readline? ( dev-perl/Term-ReadLine-Perl )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${P}"

src_compile() {
	mylltagopts=(
		PREFIX=/usr
		SYSCONFDIR=/etc
		MANDIR=/usr/share/man
		PERL_INSTALLDIRS=vendor
		DOCDIR=/usr/share/doc/${PF}
	)

	emake "${mylltagopts[@]}"
}

src_install() {
	emake DESTDIR="${D}" "${mylltagopts[@]}" install{,-doc,-man}
	dodoc Changes
	perl_delete_localpod
	# Move config to recommended location
	mv "${D}/usr/share/doc/${PF}"/config "${D}"/etc/lltag/ || die
}
