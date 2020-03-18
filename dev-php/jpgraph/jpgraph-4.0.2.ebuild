# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Object-oriented graphing library for PHP"
HOMEPAGE="http://jpgraph.net/"
# Upstream didn't have a stable download URL when this was packaged.
SRC_URI="https://dev.gentoo.org/~mjo/distfiles/${P}.tar.gz"
LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc sparc x86"
IUSE="truetype examples"

DEPEND=""
RDEPEND="truetype? ( media-fonts/corefonts )
	dev-lang/php[gd,truetype?]"

src_prepare() {
	default

	# The DejaVu fonts are now bundled with the library and don't need
	# to be found in TTF_DIR. Since most of the fonts supported by
	# JpGraph are corefonts, we point the sole TTF_DIR towards them for
	# maximum impact. Why not apply the patch unconditionally? We want
	# to avoid a situation where TTF fonts appear to work, but then
	# break without warning when the user e.g. removes corefonts. By
	# applying the patch conditionally, we ensure a dependency on
	# media-fonts/corefonts before anything will work.
	use truetype && eapply "${FILESDIR}/gentoo_ttf_dir.patch"

	# Some of the documentation and examples are shipped in the "src"
	# directory. We want them outside of that tree so that we can simply
	# call doins recursively on "src". First, rename the existing "docs"
	# directory which contains the HTML manual and class reference.
	mv docs html || die 'failed to rename "docs" directory'
	mv src/README ./ || die 'failed to relocate the README'
	mv src/Examples ./examples || die 'failed to relocate the examples'

	# These are present (duplicated) in the other Examples directory,
	# and don't work anyway.
	rm -r src/barcode || die 'failed to remove some barcode examples'

	# We'll also want to install the config file to /etc, since it may
	# need to be edited by the user.
	mv src/jpg-config.inc.php ./ || die 'failed to relocate the config file'
	rm src/jpg-config.inc.php.orig || die 'failed to remove original config file'
}

src_install() {
	dodoc README
	dodoc -r html
	use examples && dodoc -r examples

	insinto "/usr/share/php/${PN}"
	doins -r src/*

	insinto /etc
	doins jpg-config.inc.php
	# Create a symlink for the config file, because the library will only
	# look for it in its own source tree (not in /etc where we've put it).
	dosym ../../../../etc/jpg-config.inc.php "/usr/share/php/${PN}/jpg-config.inc.php"
}
