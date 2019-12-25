# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Converter for Microsoft Word, Excel, PowerPoint and RTF files to text"
HOMEPAGE="http://www.wagner.pp.ru/~vitus/software/catdoc/"
SRC_URI="http://ftp.wagner.pp.ru/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="tk"

DEPEND="tk? ( >=dev-lang/tk-8.1 )"

DOCS="CODING.STD NEWS README TODO"
# CREDITS missing by accident in catdoc-0.95

PATCHES=(
	"${FILESDIR}/${P}-parallel-make.patch"
	)

src_prepare() {
	default

	# Fix for case-insensitive filesystems
	echo ".PHONY: all install clean distclean dist" >> Makefile.in || die

	mv configure.{in,ac} || die
}

src_configure() {
	econf --with-install-root="${D}" \
		$(use_with tk wish "${EPREFIX}"/usr/bin/wish) \
		$(use_enable tk wordview)
}

src_compile() {
	emake LIB_DIR="${EPREFIX}"/usr/share/catdoc
}

src_install() {
	default

	# dev-libs/libxls and app-text/catdoc both provide xls2cvs
	if [[ -e ${ED}/usr/bin/xls2csv ]]; then
		einfo "Renaming xls2csv to xls2csv-${PN} because of bug 314657."
		mv -vf "${ED}"/usr/bin/xls2csv "${ED}"/usr/bin/xls2csv-${PN} || die
		mv -vf "${ED}"/usr/share/man/man1/xls2csv.1 "${ED}"/usr/share/man/man1/xls2csv-${PN}.1 || die
	fi
}
