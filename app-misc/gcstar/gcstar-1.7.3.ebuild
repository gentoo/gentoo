# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# GUIDE:
# - find dependencies:
#   # ebuild gcstar-1.7.3.ebuild install
# - find optional components, useful to determine IUSE flags:
#   # grep checkModule /.../work/* -R
#   # grep checkOptionalModule /.../work/* -R
# - find all modules:
#   # grep -E 'use .+;' /.../work/* -R

# TODO:
# - missing gtkspell:3 perl binding (dev-perl/gtk2-spell is masked)

EAPI=7

inherit desktop xdg

DESCRIPTION="Manage your collections of movies, games, books, music and more"
HOMEPAGE="http://www.gcstar.org/ https://gitlab.com/Kerenoc/GCstar"
# Gna permanently shut down in May 2017
# Original SRC_URI was http://download.gna.org/gcstar/${P}.tar.gz
SRC_URI="https://gitlab.com/Kerenoc/GCstar/-/archive/v${PV}/GCstar-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cddb exif mp3 stats vorbis"
#IUSE+="spell"

#	spell? ( dev-perl/gtk2-spell )
RDEPEND="dev-lang/perl[ithreads]
	dev-perl/Gtk3
	dev-perl/Gtk3-SimpleList
	dev-perl/XML-Parser
	dev-perl/XML-Simple
	dev-perl/libwww-perl[ssl]
	dev-perl/Archive-Zip
	dev-perl/JSON
	dev-perl/Locale-Codes
	cddb? ( dev-perl/Net-FreeDB )
	exif? ( media-libs/exiftool )
	mp3? ( ||
		(
			dev-perl/MP3-Info
			dev-perl/MP3-Tag
		)
	)
	stats? (
		dev-perl/Date-Calc
		dev-perl/GD[png,truetype]
		dev-perl/GDGraph
		dev-perl/GDTextUtil
	)
	vorbis? ( dev-perl/Ogg-Vorbis-Header-PurePerl )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/GCstar-v${PV}"

PATCHES=(
	"${FILESDIR}/${P}-disable-man-pages-compression.patch"
	"${FILESDIR}/${P}-fix-GCMail.patch"
)

src_install() {
	# Yes, ED *is* needed here. GCstar's install lacks any concept of DESTDIR.
	# Also temporarily disable proxy values due to LWP::Simple failing with non
	# absoulute URIs like '127.0.0.1:8080' rather than 'http://127.0.0.1:8080'.
	ftp_proxy="" http_proxy="" https_proxy="" ./gcstar/install --prefix="${ED}/usr" \
		--text --noclean --nomenu --verbose || die "install script failed"

	domenu gcstar/share/applications/gcstar.desktop
	for size in 16 22 24 32 36 48 64 72 96 128 192 256
	do
		newicon -s "${size}" gcstar/share/gcstar/icons/gcstar_${size}x${size}.png gcstar.png
	done
	newicon -s scalable gcstar/share/gcstar/icons/gcstar_scalable.svg gcstar.svg
	insinto /usr/share/mime/packages
	doins gcstar/share/applications/gcstar.xml

	dodoc README.md gcstar/CHANGELOG resources/Plugins.md
}
