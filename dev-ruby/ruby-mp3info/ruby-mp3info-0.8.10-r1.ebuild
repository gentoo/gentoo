# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="History.txt README.md"
RUBY_FAKEGEM_GEMSPEC="ruby-mp3info.gemspec"

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

all_ruby_prepare() {
	sed -i -e 's:/tmp/test.mp3:'${T}'/test.mp3:' test/test_ruby-mp3info.rb || die
}
