# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${PN}_2.5.2.99.pre2+cvs20030224

DESCRIPTION="Chinese X Input Method"
HOMEPAGE="http://cle.linux.org.tw/xcin/"
SRC_URI="
	mirror://debian/pool/main/x/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${MY_P}-1.4.diff.gz"

LICENSE="XCIN GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="debug nls unicode"

RDEPEND="
	app-i18n/libchewing
	>=app-i18n/libtabe-0.2.6
	>=sys-libs/db-4.5:*
	x11-libs/libX11
	unicode? ( media-fonts/arphicfonts )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P/_/-}"

PATCHES=(
	"${WORKDIR}"/${MY_P}-1.4.diff
	"${FILESDIR}"/${P}-glibc-2.10.patch
	"${FILESDIR}"/${P}-make.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	rm configure || die
	cd script || die
	mv configure.{in,ac} || die
	eautoreconf
	mv configure .. || die
}

src_configure() {
	econf \
		--disable-static \
		--with-xcin-rcdir="${EPREFIX}"/etc \
		--with-xcin-dir="${EPREFIX}"/usr/$(get_libdir)/xcin25 \
		--with-db-lib="${EPREFIX}"/usr/$(get_libdir) \
		--with-tabe-inc="${EPREFIX}"/usr/include/tabe \
		--with-tabe-lib="${EPREFIX}"/usr/$(get_libdir) \
		$(use_enable debug)
}

src_compile() {
	emake -j1
}

src_install() {
	emake \
		prefix="${ED}/usr" \
		program_prefix="${D}" \
		install

	# no static archives
	find "${ED}" -name '*.la' -delete || die

	local docdir
	for docdir in doc doc/En doc/En/internal doc/history doc/internal doc/modules; do
		docinto ${docdir#doc/}

		local doc
		while IFS="" read -d $'\0' -r doc; do
			if use unicode; then
					iconv -f BIG5 -t UTF-8 --output=${doc}.UTF-8 ${doc} || die
					mv ${doc}.UTF-8 ${doc} || die
			fi
			dodoc ${doc}
		done < <(find ${docdir} -maxdepth '1' -type f -print0)
	done
}
