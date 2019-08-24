# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

MY_P="wxGlade-${PV}"

DESCRIPTION="Glade-like GUI designer which can generate Python, Perl, C++ or XRC code"
HOMEPAGE="http://wxglade.sourceforge.net/"
SRC_URI="mirror://sourceforge/wxglade/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	app-arch/unzip
"

RESTRICT="test" #656934

S="${WORKDIR}/${MY_P}"

src_compile() {
	python_fix_shebang wxglade.py
}

src_install() {
	einstalldocs

	# Install a bigger icon
	newicon docs_old/html/mondrian_200x200.png ${PN}.png

	dodoc -r docs
	rm -r docs docs_old || die

	python_moduleinto /usr/lib/wxglade
	python_domodule .
	dosym /usr/share/doc/${PF}/docs /usr/lib/wxglade/docs
	fperms 775 /usr/lib/wxglade/wxglade.py
	dosym ../lib/wxglade/wxglade.py /usr/bin/wxglade

	make_desktop_entry wxglade wxGlade wxglade "Development;GUIDesigner"
}
