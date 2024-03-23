# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="The GAP Character Table Library"
SLOT="0"
SRC_URI="https://www.math.rwth-aachen.de/~Thomas.Breuer/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-gap/atlasrep"
BDEPEND="test? (
	dev-gap/browse
	dev-gap/spinsym
	dev-gap/tomlib
)"

# These are "extra" docs and not the HTML produced by GAPDoc. The glob
# gets expanded if we use a plain variable but not if we use a bash
# array.
HTML_DOCS="htm/*"

GAP_PKG_EXTRA_INSTALL=( ctbltoc data dlnames doc2 gap4 )

gap-pkg_enable_tests

src_install() {
	gap-pkg_src_install

	# This package has a "doc2" directory that contains an entirely
	# separate set of GAPDoc documentation called "CTblLibXpls." They
	# are mentioned in PackageInfo.g. On the assumption that "Xpls"
	# stands for "examples," we install it (unconditionally, and via
	# symlink) as "examples" by copying most of the GAPDoc installation
	# bits from gap-pkg_src_install().
	pushd doc2 > /dev/null || die

	local docdir="$(gap-pkg_dir)/doc2"
	insinto "${docdir}"

	local f
	for f in *.{lab,six,txt,xml}; do
		doins "${f}"
	done

	for f in *.pdf; do
		doins "${f}"
		dosym -r "${docdir}/${f}" "/usr/share/doc/${PF}/examples/${f}"
	done

	for f in *.{html,css,js,png}; do
		doins "${f}"
		dosym -r "${docdir}/${f}" "/usr/share/doc/${PF}/examples/html/${f}"
	done

	popd > /dev/null || die
}
