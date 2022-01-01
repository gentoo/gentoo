# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_DOCDIR="doc/api"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

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
IUSE=""
