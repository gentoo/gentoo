# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"

inherit distutils python vcs-snapshot

DESCRIPTION="Landslide generates a slideshow using the slides that power the html5-slides presentation"
HOMEPAGE="https://github.com/adamzap/landslide"
SRC_URI="https://github.com/adamzap/landslide/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-python/docutils
	dev-python/jinja
	dev-python/markdown
	dev-python/pygments"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
