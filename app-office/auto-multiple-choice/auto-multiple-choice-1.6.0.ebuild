# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs perl-functions latex-package

DESCRIPTION="Create and manage multiple choice questionnaries, including automated marking"
HOMEPAGE="http://www.auto-multiple-choice.net/"
SRC_URI="http://download.auto-multiple-choice.net/${PN}_${PV}_sources.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

LANGS="ar es fr ja"
# we deliberately always install de and en, since this way we dont get a problem
# with globs and empty directories...
#
for lala in ${LANGS}; do
	IUSE="${IUSE} l10n_${lala}"
done

COMMON_DEPEND="
	app-text/texlive[cjk,extra,graphics,png,pstricks,science,truetype,xml,X,luatex,xetex,humanities,publishers,l10n_zh]
	app-text/poppler:=
	dev-perl/XML-LibXML
	media-fonts/ipaex
	media-libs/netpbm[png]
	media-libs/opencv
	l10n_fr? ( app-text/texlive[l10n_fr] )
	l10n_ja? ( app-text/texlive[l10n_ja] )
"
DEPEND="${COMMON_DEPEND}
	app-text/dblatex
	app-text/docbook-xml-simple-dtd:*
	app-text/docbook-xsl-stylesheets
"
RDEPEND="${COMMON_DEPEND}
	app-text/pdftk
	dev-lang/perl:=
	dev-perl/Glib-Object-Introspection
	dev-perl/Gtk3
	media-gfx/imagemagick
	dev-perl/XML-Writer
	dev-perl/Archive-Zip
	dev-perl/DBI
	dev-perl/Pango
	dev-perl/Text-CSV
	dev-perl/DBD-SQLite
	dev-perl/Net-CUPS
	dev-perl/Email-Address
	dev-perl/Email-MIME
	dev-perl/Email-Sender
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.2-conf.patch"
)

src_prepare() {
	default

	local la
	for la in ${LANGS} ; do
		if ! use l10n_${la} ; then
			# remove languages that we dont want to install. no error on nonexisting files.
			rm -vf "I18N/lang/${la}.po"
			rm -vf "doc/auto-multiple-choice.${la}.in.xml" "doc/doc-xhtml-site.${la}.xsl.in"
			rm -rvf "doc/html/auto-multiple-choice.${la}" "doc/modeles/${la}"
			sed -e "s: doc/doc-xhtml-site\\.${la}\\.xsl: :g" -i Makefile || die
		fi
	done
}

src_compile() {
	perl_set_version
	export VENDOR_LIB PVR

	export MAKEOPTS="-j1"
	# when doing a parallel build, the package is acting decidedly odd
	# e.g., the build seems to succeed while actually stuff fails
	# and subsequent error messages do not have any relation to the real problem
	# So let's keep this also for easier debugging

	emake \
			GCC_NETPBM="-I/usr/include/netpbm/ -lnetpbm" \
			GCC="$(tc-getCC)" \
			GCC_PP="$(tc-getCXX)"
}

src_install() {
	default
	mv -v "${ED}/usr/share/doc/${PV}"/* "${ED}/usr/share/doc/${PF}/" || die
	rmdir -v "${ED}/usr/share/doc/${PV}" || die
}
