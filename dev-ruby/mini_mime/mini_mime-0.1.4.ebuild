# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="mini_mime.gemspec"

inherit ruby-fakegem

DESCRIPTION="A lightweight mime type lookup toy"
HOMEPAGE="https://github.com/discourse/mini_mime"
SRC_URI="https://github.com/discourse/mini_mime/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
