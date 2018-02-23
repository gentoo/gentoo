# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.md"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby library for access to mp3 files (internal infos and tags)"
HOMEPAGE="http://rubyforge.org/projects/ruby-mp3info/"
SRC_URI="https://github.com/moumar/${PN}/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND+=" test? ( media-sound/id3v2 )"

ruby_add_bdepend "test? ( dev-ruby/hoe dev-ruby/test-unit:2 )"
