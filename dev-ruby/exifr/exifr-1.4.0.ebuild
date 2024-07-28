# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_DOCDIR="doc/api"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library to read EXIF info from JPEG and TIFF images"
HOMEPAGE="https://github.com/remvee/exifr/"
SRC_URI="https://github.com/remvee/exifr/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-release-${PV}"

# License is not specified in source distribution but is in the GitHub
# repository.
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
