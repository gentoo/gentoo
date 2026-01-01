# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_DOCDIR="doc/api"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library to read EXIF info from JPEG and TIFF images"
HOMEPAGE="https://codeberg.org/rwv/exifr"
SRC_URI="https://codeberg.org/rwv/exifr/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
