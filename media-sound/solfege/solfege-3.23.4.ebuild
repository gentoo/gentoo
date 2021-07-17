# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
PYTHON_REQ_USE="sqlite"
inherit autotools python-single-r1

DESCRIPTION="GNU program to help practicing ear training"
HOMEPAGE="https://www.gnu.org/software/solfege/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa oss"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="${PYTHON_DEPS}
	>=app-text/docbook-xsl-stylesheets-1.60
	app-text/txt2man
	dev-lang/swig
	dev-libs/libxslt
	dev-util/itstool
	sys-apps/texinfo
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3
	alsa? ( dev-python/pyalsa )
	!oss? ( media-sound/timidity++ )
"
DEPEND="${RDEPEND}"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-no-xmllint.patch"
	"${FILESDIR}/${P}-fix-menubar.patch"
	"${FILESDIR}/${P}-itstool.patch"
	"${FILESDIR}/${P}-topdocs-encodings.patch"
	"${FILESDIR}/${P}-fix-webbrowser-module.patch"
)

src_prepare() {
	default

	# fix encoding of the Hungarian translation, thanks to Arch Linux
	iconv -f ISO-8859-2 -t UTF-8 po/hu.po -o po/hu.po.new || die
	sed -i 's/charset=iso-8859-2/charset=utf-8/' po/hu.po.new || die
	mv po/hu.po.new po/hu.po || die

	sed -E 's|(PYTHON_INCLUDES=).+|\1"$($(tc-getPKG_CONFIG) --cflags-only-I python3)"|g' \
		-i acinclude.m4 || die

	eautoreconf
}

src_configure() {
	econf $(use_enable oss oss-sound)
}

src_compile() {
	emake skipmanual=yes
}

src_install() {
	emake DESTDIR="${ED}" nopycompile=YES skipmanual=yes install
	dodoc AUTHORS changelog FAQ README
}
