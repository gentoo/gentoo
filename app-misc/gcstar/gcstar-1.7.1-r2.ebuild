# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit desktop xdg

DESCRIPTION="Manage your collections of movies, games, books, music and more"
HOMEPAGE="http://www.gcstar.org/"
# Gna permanently shut down in May 2017
# Original SRC_URI was http://download.gna.org/gcstar/${P}.tar.gz
SRC_URI="https://launchpad.net/gcstar/1.7/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="cddb mp3 spell stats tellico vorbis"

RDEPEND="dev-lang/perl
	dev-perl/Archive-Zip
	dev-perl/DateTime-Format-Strptime
	dev-perl/Gtk2
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/XML-Parser
	dev-perl/XML-Simple
	virtual/perl-Archive-Tar
	virtual/perl-Encode
	virtual/perl-Getopt-Long
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-IO-Compress
	virtual/perl-libnet
	virtual/perl-Storable
	virtual/perl-Time-Piece
	cddb? ( dev-perl/Net-FreeDB )
	mp3? ( dev-perl/MP3-Info dev-perl/MP3-Tag )
	spell? ( dev-perl/gtk2-spell )
	stats? ( dev-perl/Date-Calc
		dev-perl/GD[png(+),truetype(+)] )
	tellico? ( virtual/perl-Digest-MD5
		virtual/perl-MIME-Base64 )
	vorbis? ( dev-perl/Ogg-Vorbis-Header-PurePerl )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/${PN}-1.4.0-man.patch" )

src_install() {
	# Yes, ED *is* needed here. GCstar's install lacks any concept of DESTDIR.
	./install --prefix="${ED}usr" \
		--noclean --nomenu || die "install script failed"

	domenu share/applications/gcstar.desktop
	for size in 16 22 24 32 36 48 64 72 96 128 256
	do
		newicon -s "${size}" share/gcstar/icons/gcstar_${size}x${size}.png gcstar.png
	done
	newicon -s scalable share/gcstar/icons/gcstar_scalable.svg gcstar.svg
	insinto /usr/share/mime/packages
	doins share/applications/gcstar.xml

	dodoc CHANGELOG README README.fr
}
